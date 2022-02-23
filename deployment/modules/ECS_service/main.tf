resource "aws_ecs_service" "practice_ecs_service" {
  name            = replace(replace("practice_ecs_${var.ecs_task_arn}",":","-"),"/","-")
  launch_type     = "EC2"
  cluster         = var.ecs_cluster_id
  task_definition = var.ecs_task_arn
  desired_count   = 3

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-2a, eu-west-2b, eu-west-2c]"
  }
}