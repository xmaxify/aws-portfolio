provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "serverless-api"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
