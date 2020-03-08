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
  repo_access = {
    for repo, obj in var.repositories : repo => {
      read_access = lookup(obj, "read_arns", [])
      write_access = lookup(obj, "write_arns", [])
    }
  }
}

data "aws_iam_policy_document" "this" {
  for_each = local.repo_access
  
  statement {
    sid = "ECRRead"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    principals {
      type = "AWS"
      identifiers = lookup(local.repo_access[each.key], "read_access", [])
    }
  }
  statement {
    sid = "ECRPush"
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    principals {
      type = "AWS"
      identifiers = lookup(local.repo_access[each.key], "write_access", [])
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

resource "aws_ecr_repository_policy" "this" {
  for_each = var.repositories

  repository = aws_ecr_repository.this[each.key].name
  policy = data.aws_iam_policy_document.this[each.key].json
}
