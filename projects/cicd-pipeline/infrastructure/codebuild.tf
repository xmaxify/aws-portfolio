resource "aws_codebuild_project" "deploy" {
  name          = "maxify-sh-deploy"
  description   = "Sync static site files to S3 and invalidate CloudFront"
  service_role  = aws_iam_role.codebuild.arn
  build_timeout = 10

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type            = "LINUX_CONTAINER"
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux-x86_64-standard:5.0"
    privileged_mode = false

    environment_variable {
      name  = "S3_BUCKET"
      value = var.s3_bucket_name
    }

    environment_variable {
      name  = "CF_DISTRIBUTION_ID"
      value = var.cloudfront_distribution_id
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/maxify-sh-deploy"
      stream_name = "build"
    }
  }
}