# Enterprise Terraform Infrastructure on AWS

## 📌 Project Overview

This project demonstrates how to build enterprise-grade AWS infrastructure using Terraform modules and Infrastructure as Code (IaC).

## 🛠 Technologies

- Terraform
- AWS
- Git & GitHub
- Jenkins (Upcoming)
- Docker (Upcoming)
- Amazon ECR (Upcoming)
- Amazon EKS (Upcoming)
- Prometheus & Grafana (Upcoming)

---

## Project Structure

```text
terraform/
├── backend/
├── live/
│   ├── prod/
│   └── uat/
├── modules/
│   ├── networking/
│   ├── ec2/
│   ├── iam/
│   └── security-groups/
```

---

## Infrastructure

### Phase 1 - Networking

- ✅ VPC
- ⏳ Public Subnets
- ⏳ Private Subnets
- ⏳ Internet Gateway
- ⏳ NAT Gateway
- ⏳ Route Tables

### Phase 2

- EC2
- IAM
- Security Groups

### Phase 3

- S3 Backend
- DynamoDB State Locking

### Phase 4

- Jenkins CI/CD
- Docker
- Amazon ECR
- Amazon EKS

---

## AWS Region

```
us-east-1
```

---

## Current Status

✅ VPC Successfully Created using Terraform
