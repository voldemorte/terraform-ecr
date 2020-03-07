locals {
  options = {
    for repo, obj in var.repositories : repo => lookup(obj, "options", {})
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
