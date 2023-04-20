resource "aws_ecr_repository" "docker" {
  for_each             = toset(var.docker_repositories)
  name                 = each.key
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "rule" {
  for_each   = toset(var.docker_repositories)
  repository = aws_ecr_repository.docker[each.value].name

  depends_on = [aws_ecr_repository.docker]

  policy = jsonencode({
    rules = [{
      action = {
        type = "expire"
      }
      description  = "Keep last 30 images"
      rulePriority = 1
      selection = {
        countNumber = 30
        countType   = "imageCountMoreThan"
        tagPrefixList = [
          "dev",
        ]
        tagStatus = "tagged"
      }
    }]
  })
}
