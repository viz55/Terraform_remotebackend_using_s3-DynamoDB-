# Terraform Remote Backend with S3 and DynamoDB

This project sets up an **S3 bucket** and a **DynamoDB table** to be used as a **remote backend** for storing Terraform state files and enabling state locking.

---

## What This Does
- Creates an **S3 bucket** for storing Terraform state files.
- Enables **versioning** on the bucket (so state history is preserved).
- Enables **server-side encryption (SSE-KMS)** for security.
- Creates a **DynamoDB table** for Terraform state locking.
- Prevents multiple users or pipelines from writing to the state at the same time.

---

## Architecture
Terraform will:
1. Store the `terraform.tfstate` file in the S3 bucket.  
2. Use the DynamoDB table to lock the state during `terraform plan` or `terraform apply`.  

This avoids state corruption in teams or CI/CD.

---

## Prerequisites
- AWS account with appropriate IAM permissions:
  - `s3:*` on the backend bucket
  - `dynamodb:*` on the lock table
  - `kms:*` if using custom KMS keys
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 0.12
- AWS CLI configured with credentials.

---

## Setup Instructions

### 1. Clone this repo
```
git clone <your-repo-url>
cd <your-repo>
```
Open remote_state file using `cd` command.

#### Note:- Move the `backend.tf` file to some other directory or copy the format in a notepad to use it later. The `backend.tf` file should not be in the same folder as `boot.tf` before initialising terraform.

### 2. Initialise Terraform
```
terraform init
```

### 3. Apply the configuration
This will create the S3 bucket, DynamoDB table, and KMS key: -
```
terraform apply
```
After applying the configuration, you should be getting an output like this:

<img width="1024" height="370" alt="tf apply" src="https://github.com/user-attachments/assets/66f5f0cd-f34c-4a3f-b31d-d0c5a5ccef6b" />

---

## Backend Configuration
After applying `boot.tf`, update your Terraform project’s backend block using `backend.tf` file:

`bucket` → Must match the S3 bucket created in `boot.tf`

`key` → Path where the state file will live (organize by env/app)

`region` → Region where the bucket/table were created

`dynamodb_table` → Name of the DynamoDB table



### Run:
```
terraform init -migrate-state
#or
terraform init
```

you will be getting an output like this:

<img width="691" height="217" alt="backend tf" src="https://github.com/user-attachments/assets/d24ca58a-6c15-4b80-85dc-0aeb509687c8" />

---

## Verify Locking with DynamoDB

Run `terraform plan` in a project using this backend.

While it’s running, check the DynamoDB table:
```
aws dynamodb scan --table-name terraform-lock
```
You should see a lock entry.

When Terraform finishes, the lock is released (table looks empty again).

We can also see that there is a Terraform file with `.tfstate` extension formed inside the s3 bucket.

---
#### Note:-The `local_state` file can be used as a simple separate project to check the functtionality of terraform.
---
