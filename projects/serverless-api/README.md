# Serverless API

REST API for tracking website visitors at [api.maxify.sh](https://api.maxify.sh). Increments and returns a persistent visitor counter stored in DynamoDB.

## Architecture

```
Browser (maxify.sh)
  │
  └── POST https://api.maxify.sh/visitors
          │
          └── API Gateway (HTTP API)
                  │ throttle: 10 req/s, burst 20
                  └── Lambda: maxify-sh-visitor-counter (Python 3.12, ARM64)
                          │
                          └── DynamoDB: maxify-sh-visitors
                                  item: { id: "visitors", count: N }
```

- CORS is restricted to `https://maxify.sh`
- Custom domain `api.maxify.sh` with ACM certificate and Cloudflare DNS

## Endpoint

```
POST https://api.maxify.sh/visitors
```

Increments the visitor counter and returns the updated count.

## Services Used

| Service | Role |
|---------|------|
| **API Gateway** | HTTP API with single POST route, CORS, throttling, custom domain |
| **Lambda** | Business logic - increments DynamoDB counter (Python 3.12, ARM64, 128 MB) |
| **DynamoDB** | On-demand table storing visitor count (`id: "visitors", count: N`) |
| **IAM** | Least-privilege execution role: CloudWatch logs + DynamoDB GetItem/UpdateItem |
| **ACM** | SSL certificate for `api.maxify.sh` (us-east-1) |
| **Cloudflare** | DNS - CNAME record for `api.maxify.sh` |

## Infrastructure

| File | Description |
|------|-------------|
| `lambda.tf` | Lambda function, packaging, environment variables |
| `api_gateway.tf` | HTTP API, route, CORS, stage, throttling, custom domain |
| `dynamodb.tf` | DynamoDB table with PITR enabled |
| `iam.tf` | Lambda execution role and DynamoDB access policy |
| `acm.tf` | ACM certificate with DNS validation |
| `dns.tf` | Cloudflare DNS record for `api.maxify.sh` |
| `variables.tf` | Input variables |
| `outputs.tf` | API endpoint URL |
| `providers.tf` | AWS + Cloudflare provider config |

## Lambda Function

**File:** `src/handler.py`

| Setting | Value |
|---------|-------|
| Runtime | Python 3.12 |
| Architecture | ARM64 |
| Memory | 128 MB |
| Timeout | 10 seconds |
| Handler | `handler.handler` |

**Environment variables:**
- `TABLE_NAME` - DynamoDB table name
- `ALLOWED_ORIGIN` - CORS allowed origin (`https://maxify.sh`)

## Key Configuration

| Setting | Value |
|---------|-------|
| API Domain | `api.maxify.sh` |
| CORS Allowed Origin | `https://maxify.sh` |
| CORS Allowed Method | POST |
| Throttle Rate | 10 req/s |
| Throttle Burst | 20 |
| DynamoDB Table | `maxify-sh-visitors` |
| DynamoDB Billing | PAY_PER_REQUEST |
| TLS Minimum | TLS 1.2 |

## Deployment

> **Prerequisite:** The Terraform backend must exist before applying. If not yet provisioned, run [bootstrap](../../bootstrap/README.md) first.

```bash
aws-vault exec <profile> --no-session $SHELL

cd projects/serverless-api/infrastructure
terraform init
terraform plan
terraform apply
```