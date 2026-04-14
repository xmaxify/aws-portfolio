variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "allowed_origin" {
  description = "Origin allowed to call the API (CORS)"
  type        = string
}

variable "api_domain_name" {
  description = "Custom domain name for the API"
  type        = string
  default     = "api.maxify.sh"
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for maxify.sh"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS edit permissions"
  type        = string
  sensitive   = true
}
