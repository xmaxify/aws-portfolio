variable "aws_region" {
  description = "AWS region for the main infrastructure"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Root domain name (e.g. example.com)"
  type        = string
}

variable "www_redirect" {
  description = "Whether to create a www subdomain that redirects to the root domain"
  type        = bool
  default     = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the domain (found in Cloudflare dashboard → Overview)"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token with Zone:DNS:Edit permission"
  type        = string
  sensitive   = true
}

