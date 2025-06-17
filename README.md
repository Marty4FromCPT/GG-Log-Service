# GG Log Service (Serverless Logging App)

This project is a fully serverless logging service using:
- AWS Lambda (Python)
- Amazon API Gateway
- DynamoDB (with encryption)
- GitHub Actions for CI/CD
- Terraform (manual provisioning)

---

## 🚀 Features

- `POST /submit` – Receive a log entry
- `GET /logs` – Retrieve the 100 most recent logs
- Logs include: `id`, `datetime`, `severity`, and `message`
- Secure by default with IAM and least privilege roles

---

## 📁 Structure

```bash
functions/
  ├── submit_log/handler.py
  └── get_logs/handler.py
terraform/
  ├── main.tf, lambda.tf, api_gateway.tf, etc.
.github/
  └── workflows/deploy.yml

Automation Notes
Lambda CI/CD runs automatically on pushes to functions/**

Terraform is kept separate and manual by design (to avoid unintended infrastructure changes)

🔐 Security
Least privilege IAM for Lambda

DynamoDB encryption (KMS)

No plaintext secrets — GitHub uses OIDC for AWS auth


Author
Martin Botha
Cloud | DevOps | Platform Engineering
Cape Town, South Africa