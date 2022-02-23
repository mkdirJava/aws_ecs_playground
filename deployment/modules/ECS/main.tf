resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_practice"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role       = "${aws_iam_role.instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "instance" {
  name = "app-ecs-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance" {
  name = "app-ecs-instance-profile"
  role = "${aws_iam_role.instance.name}"
}

resource "aws_launch_template" "cluster_lt" {
  name_prefix   = "ecs_cluster"
  image_id      = "ami-0aa8289e53e65418b"
  instance_type = "t3.micro"
  
  user_data = base64encode("#!/bin/bash \n echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} > /etc/ecs/ecs.config")
  iam_instance_profile {
    name = aws_iam_instance_profile.instance.name
  }
}

resource "aws_autoscaling_group" "cluster_asg" {
  launch_template {
    id      = aws_launch_template.cluster_lt.id
    version = "$Latest"
  }
   tag {
    key                 = "Name"
    value               = "ecs_cluster"
    propagate_at_launch = true
  }
  
  desired_capacity = 2
  max_size           = 5
  min_size           = 1
  availability_zones = ["eu-west-2a","eu-west-2b","eu-west-2c"]

}

resource "aws_ecs_capacity_provider" "cluster_provider"{
  name = "cluster_provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.cluster_asg.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_providers"{
  cluster_name =aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.cluster_provider.name]
  default_capacity_provider_strategy {
    base= 1
    weight = 100
    capacity_provider = aws_ecs_capacity_provider.cluster_provider.name
  }
}
