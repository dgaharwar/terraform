#terraform {
#  required_version = ">= 1.5.5"

#  required_providers {
#    aws = {
#       source                = "hashicorp/aws"
#       version               = ">= 4.9"
      # configuration_aliases = [aws.lambda_region]
#    }
#  }
#}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.79"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
    }
  }
}
