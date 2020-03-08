variable "repositories" {
  description = "A map of repositories"
  // Setting a default for example purpose
  default = {
    alpine = {
      options = {
        scan_on_push         = true
        image_tag_mutability = "MUTABLE"
      }
      // For lifecycle rules please set the structure as described
      // in the selection section of
      // https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html
      lifecycle_rules = [
        {
          tagStatus = "untagged"
          // In case of untagged images be sure to not include
          // 'tagPrefixList' to avoid failures
          countType   = "sinceImagePushed"
          countNumber = 14
          countUnit   = "days"
        },
        {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
      ]
      // These ARNS can be accounts that can read repository images or individual IAM users/roles
      read_arns = [
        "arn:aws:iam::983456789123:user/test",
        "arn:aws:iam::123456789101:role/awesome"
      ]
      write_arns = [
        "arn:aws:iam::983456789123:user/test",
        "arn:aws:iam::123456789101:role/awesome"
      ]
    },
    debian = {
      options = {
        scan_on_push         = true
        image_tag_mutability = "MUTABLE"
      }
      lifecycle_rules = [
        {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countNumber = 14
          countUnit   = "days"
        },
        {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
      ]
      read_arns = [
        "arn:aws:iam::983456789123:user/test",
        "arn:aws:iam::123456789101:role/awesome"
      ]
      write_arns = [
        "arn:aws:iam::983456789123:user/test",
        "arn:aws:iam::123456789101:role/awesome"
      ]
    }
  }
}
