# AWS Portfolio

A collection of AWS projects showcasing cloud architecture and infrastructure-as-code.

## Projects

| Project | Description | Services |
|---------|-------------|----------|
| [static-site](./projects/static-site/) | | S3, CloudFront, Route53, ACM |
| [serverless-api](./projects/serverless-api/) | | Lambda, API Gateway, DynamoDB, IAM |

## Structure

```
projects/
  {project-name}/
    infrastructure/   # IaC
    src/              # application code
    docs/             # diagrams, notes
shared/
  modules/            # reusable IaC modules
  scripts/            # deploy helpers
docs/
  architecture/       # cross-project architecture diagrams
```