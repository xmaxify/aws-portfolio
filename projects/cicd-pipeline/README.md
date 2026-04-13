# CI/CD Pipeline

Automated deployment pipeline for [maxify.sh](https://maxify.sh). Triggers on every push to the `main` branch of the GitHub repository, syncs static files to S3, and invalidates the CloudFront cache.

## Architecture

```
GitHub (xmaxify/maxify.sh, branch: main)
  │
  └── CodeStar Connection (must be manually activated)
          │
          └── CodePipeline: maxify-sh-deploy
                  │
                  ├── Stage 1 - Source
                  │       Downloads repo as CODE_ZIP artifact → S3 artifact store
                  │
                  └── Stage 2 - Deploy
                          CodeBuild: maxify-sh-deploy
                            ├── aws s3 sync → S3 bucket: maxify.sh
                            └── aws cloudfront create-invalidation → <cloudfront-distribution-id>
```

## Services Used

| Service | Role |
|---------|------|
| **CodePipeline** | Orchestrates source + deploy stages, triggered by GitHub push |
| **CodeBuild** | Runs `buildspec.yml` - syncs S3 and invalidates CloudFront |
| **S3** | Artifact store (`maxify-sh-pipeline-artifacts`) with 30-day lifecycle |
| **CodeStar Connections** | Secure GitHub OAuth connection (requires manual activation) |
| **IAM** | Least-privilege roles for CodePipeline and CodeBuild |

## Infrastructure

| File | Description |
|------|-------------|
| `codepipeline.tf` | Pipeline definition with Source and Deploy stages |
| `codebuild.tf` | CodeBuild project referencing `buildspec.yml` from the app repo |
| `s3.tf` | Artifact store bucket with versioning and 30-day expiry lifecycle |
| `iam.tf` | IAM roles for CodePipeline and CodeBuild with scoped permissions |
| `variables.tf` | Input variables |
| `outputs.tf` | Pipeline name, CodeStar connection ARN and status |
| `providers.tf` | AWS provider config |

## Key Configuration

| Setting | Value |
|---------|-------|
| GitHub Owner | `xmaxify` |
| GitHub Repository | `maxify.sh` |
| GitHub Branch | `main` |
| Pipeline Name | `maxify-sh-deploy` |
| S3 Site Bucket | `maxify.sh` |
| Artifact Store | `maxify-sh-pipeline-artifacts` |
| Artifact Retention | 30 days |
| CodeBuild Image | `aws/codebuild/amazonlinux-x86_64-standard:5.0` |
| CodeBuild Timeout | 10 minutes |
| AWS Region | `eu-west-1` |

## Deployment

> **Prerequisite:** The Terraform backend must exist before applying. If not yet provisioned, run [bootstrap](../../bootstrap/README.md) first.

```bash
aws-vault exec <profile> --no-session $SHELL

cd projects/cicd-pipeline/infrastructure
terraform init
terraform plan
terraform apply
```

> **Important:** After the first `terraform apply`, the CodeStar Connection must be manually activated in the AWS Console under **Developer Tools → Connections** before the pipeline can pull from GitHub. The connection status must be `AVAILABLE`.
>
> During activation, AWS installs a GitHub App in your GitHub account. You must explicitly grant that app access to the `maxify.sh` repository (it is not granted to all repositories by default). Without this step the pipeline will fail at the Source stage.

The `buildspec.yml` file referenced by CodeBuild must exist in the root of the `xmaxify/maxify.sh` GitHub repository.