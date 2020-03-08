locals {
  options = {
    for repo, obj in var.repositories : repo => lookup(obj, "options", {})
  }
  lifecycle_policy = {
    for repo, obj in var.repositories : repo => {
      rules = [
        for rule in lookup(obj, "lifecycle_rules", []) : {
          rulePriority = index(lookup(obj, "lifecycle_rules", []), rule) + 1
          action = {
            type = "expire"
          }
          selection = rule
        }
      ]
    }
  }
}

resource "aws_ecr_repository" "this" {
  for_each = var.repositories

  name                 = each.key
  image_tag_mutability = lookup(local.options[each.key], "image_tag_mutability", "MUTABLE")

  image_scanning_configuration {
    scan_on_push = lookup(local.options[each.key], "scan_on_push", true)
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = var.repositories
  repository = aws_ecr_repository.this[each.key].name
  policy     = jsonencode(local.lifecycle_policy[each.key])
}
