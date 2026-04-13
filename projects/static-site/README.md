# Static Site

Hosts [maxify.sh](https://maxify.sh) as a static website on S3, distributed globally via CloudFront with HTTPS enforced.

## Architecture

```
Browser
  │
  └── Cloudflare DNS
          │
          └── CloudFront
                  │
                  └── S3 bucket: maxify.sh
```

- DNS is managed by Cloudflare
- `www.maxify.sh` redirects to `maxify.sh` via a separate S3 redirect bucket
- SSL certificate issued by ACM in `us-east-1` (CloudFront requirement)

## Services Used

| Service | Role |
|---------|------|
| **S3** | Static file storage - private bucket, versioning enabled, encrypted |
| **CloudFront** | CDN + HTTPS termination, HTTP→HTTPS redirect |
| **ACM** | SSL/TLS certificate with DNS validation (us-east-1) |
| **Cloudflare** | DNS  |

## Infrastructure

| File | Description |
|------|-------------|
| `s3.tf` | S3 bucket with versioning, encryption, and public-access block |
| `cloudfront.tf` | CloudFront distribution, cache policy, security headers, custom error responses |
| `acm.tf` | ACM certificate with DNS validation |
| `dns.tf` | Cloudflare DNS records |
| `variables.tf` | Input variables |
| `outputs.tf` | Distribution ID, bucket name, site URL |
| `providers.tf` | AWS + Cloudflare provider config |

## Key Configuration

| Setting | Value |
|---------|-------|
| Domain | `maxify.sh` |
| AWS Region | `eu-west-1` |
| S3 Bucket | `maxify.sh` |
| Default root object | `index.html` |
| 403 error response | `/404.html` (404 status) |

## Deployment

> **Prerequisite:** The Terraform backend must exist before applying. If not yet provisioned, run [bootstrap](../../bootstrap/README.md) first.

Apply from the `infrastructure/` directory:

```bash
aws-vault exec <profile> --no-session $SHELL

cd projects/static-site/infrastructure
terraform init
terraform plan
terraform apply
```

Sync content and invalidate cache handled automatically by the [cicd-pipeline](../cicd-pipeline/))