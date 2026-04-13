# Bootstrap

Provisions the Terraform remote backend used by all projects in this repository. Must be applied **once before any other project**.

## Services Used

| Service | Role |
|---------|------|
| **S3** | Stores Terraform state files - versioning enabled, AES256 encryption, public access blocked |
| **DynamoDB** | State locking - prevents concurrent `terraform apply` runs |

## Infrastructure

| File | Description |
|------|-------------|
| `main.tf` | S3 state bucket and DynamoDB lock table |
| `outputs.tf` | Bucket name and table name |
| `providers.tf` | AWS provider config |
| `versions.tf` | Provider version constraints |

## Key Configuration

| Setting | Value |
|---------|-------|
| S3 Bucket | `maxify-sh-tfstate` |
| DynamoDB Table | `maxify-sh-tflock` |
| DynamoDB Hash Key | `LockID` |
| AWS Region | `eu-west-1` |

## Deployment

> **Run this first.** All other projects depend on this backend being available.

```bash
aws-vault exec <profile> --no-session $SHELL

cd bootstrap
terraform init
terraform plan
terraform apply
```

The state for bootstrap itself is stored locally (`terraform.tfstate`) - this is intentional, as there is no remote backend yet at this point.