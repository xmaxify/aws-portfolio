output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.site.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (used for cache invalidation)"
  value       = aws_cloudfront_distribution.site.id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting site files"
  value       = aws_s3_bucket.site.bucket
}

output "site_url" {
  description = "Public URL of the site"
  value       = "https://${var.domain_name}"
}