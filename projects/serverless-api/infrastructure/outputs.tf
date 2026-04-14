output "api_endpoint" {
  description = "Visitor counter API endpoint"
  value       = "https://${aws_apigatewayv2_domain_name.api.domain_name}${regex("^[A-Z]+ (/.*)", aws_apigatewayv2_route.visit.route_key)[0]}"
}
