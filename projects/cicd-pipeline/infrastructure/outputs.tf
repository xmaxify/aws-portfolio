output "pipeline_name" {
  description = "CodePipeline name"
  value       = aws_codepipeline.site.name
}

output "codestar_connection_arn" {
  description = "CodeStar Connection ARN - must be activated manually in AWS Console before pipeline can run"
  value       = aws_codestarconnections_connection.github.arn
}

output "codestar_connection_status" {
  description = "CodeStar Connection status - must be AVAILABLE before pipeline can run"
  value       = aws_codestarconnections_connection.github.connection_status
}
