resource "cloudflare_dns_record" "api" {
  zone_id = var.cloudflare_zone_id
  name    = "api"
  type    = "CNAME"
  content = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
  proxied = false
  ttl     = 1
}