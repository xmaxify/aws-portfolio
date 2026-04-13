provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "cicd-pipeline"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}