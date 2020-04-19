output "ecr_repositories" {
  value = {
    web_server = aws_ecr_repository.web_server
    server_app = aws_ecr_repository.server_app
  }
}
