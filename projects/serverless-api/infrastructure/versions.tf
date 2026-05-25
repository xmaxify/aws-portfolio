terraform {
  required_version = "~> 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "maxify-sh-tfstate"
    key            = "serverless-api/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "maxify-sh-tflock"
    encrypt        = true
  }
}
