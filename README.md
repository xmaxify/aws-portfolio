# AWS Portfolio

A collection of AWS projects showcasing cloud architecture and infrastructure-as-code for [maxify.sh](https://maxify.sh).

## Projects

| Project                                      | Description                                              | Services                                      |
| -------------------------------------------- | -------------------------------------------------------- | --------------------------------------------- |
| [static-site](./projects/static-site/)       | Static website hosted on S3, distributed via CloudFront  | S3, CloudFront, ACM, Route53 (Cloudflare DNS) |
| [serverless-api](./projects/serverless-api/) | Serverless visitor counter REST API                      | Lambda, API Gateway, DynamoDB, IAM            |
| [cicd-pipeline](./projects/cicd-pipeline/)   | Automated deployment pipeline triggered by GitHub pushes | CodePipeline, CodeBuild, IAM                  |

## Architecture

```
GitHub (xmaxify/maxify.sh)
    │
    └── CodePipeline (cicd-pipeline)
            │
            └── CodeBuild ──► S3 (maxify.sh) ──► CloudFront (maxify.sh)
                                                        │
                                              Visitors (browser)
                                                        │
                                              API Gateway (api.maxify.sh)
                                                        │
                                                    Lambda
                                                        │
                                                  DynamoDB (visitor counter)
```

## Infrastructure

All projects use Terraform with remote state stored in S3 (`maxify-sh-tfstate`) and DynamoDB locking (`maxify-sh-tflock`). The backend is provisioned by [`bootstrap/`](./bootstrap/) and must be applied once before any project.

**AWS Region:** `eu-west-1` (Ireland)  
**Domain:** `maxify.sh` (DNS managed by Cloudflare)

## Getting Started

1. **Provision the backend** - see [bootstrap/README.md](./bootstrap/README.md)
2. Deploy projects in any order from their respective `infrastructure/` directories

## Repository Structure

```
bootstrap/              # Terraform backend (S3 state bucket + DynamoDB lock table)
projects/
  static-site/
    infrastructure/     # Terraform: S3, CloudFront, ACM, DNS
    docs/               # Architecture diagrams
  serverless-api/
    infrastructure/     # Terraform: Lambda, API Gateway, DynamoDB, IAM, ACM, DNS
    src/                # Lambda handler
    docs/               # Architecture diagrams
  cicd-pipeline/
    infrastructure/     # Terraform: CodePipeline, CodeBuild, IAM
shared/
  modules/              # Reusable Terraform modules
  scripts/              # Shared deployment helpers
docs/
  architecture/         # Cross-project architecture diagrams
```
