terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "mycompany/aws"
      version = "~> 5.0"
    }
  }
}
