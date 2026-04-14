provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "static-site"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# ACM certificates for CloudFront must be created in us-east-1
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html#https-requirements-aws-region
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "static-site"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}
