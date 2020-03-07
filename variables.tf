variable "repositories" {
  description = "A map of repositories"
  default     = {
    alpine = {
      options = {
        scan_on_push         = true
        image_tag_mutability = "MUTABLE"
      }
      lifecycle_rules = [
        {
          tag_status      = "untagged"
          tag_prefix_list = []
          count_type      = "sinceImagePushed"
          count_number    = "14"
        },
        {
          tag_status      = "tagged"
          tag_prefix_list = ["v"]
          count_type      = "imageCountMoreThan"
          count_number    = "30"
        }
      ]
    },
    debian = {
      options = {
        scan_on_push          = true
        image_tag_mutability  = "MUTABLE"
      }
      lifecycle_rules = [
        {
          tag_status      = "untagged"
          tag_prefix_list = []
          count_type      = "sinceImagePushed"
          count_number    = "14"
        },
        {
          tag_status      = "tagged"
          tag_prefix_list = ["v"]
          count_type      = "imageCountMoreThan"
          count_number    = "30"
        }
      ]
    }
  }
}
