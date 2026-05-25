terraform {
  required_version = "~> 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "maxify-sh-tfstate"
    key            = "cicd-pipeline/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "maxify-sh-tflock"
    encrypt        = true
  }
}
