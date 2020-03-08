output "repository_arns" {
  value = {
    for repository in aws_ecr_repository.this :
    repository.name => repository.arn
  }
}

output "repository_urls" {
  value = {
    for repository in aws_ecr_repository.this :
    repository.name => repository.repository_url
  }
}
