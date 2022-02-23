output "ecr_url" {
  description = "URL of the created ECR"
  value       = aws_ecr_repository.ecr_practice.repository_url
}

output "ecr_arn" {
  description = "ARN of the created ECR"
  value       = aws_ecr_repository.ecr_practice.arn
}
