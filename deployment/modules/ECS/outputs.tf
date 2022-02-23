output "ecs_cluster_arn" {
  description = "ARN of the created ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_cluster_id" {
  description = "ARN of the created ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.id
}