# 📝 GG-Log-Service (AWS Serverless Logging API)

This project is a fully serverless, Infrastructure-as-Code (IaC) driven log service on AWS. It demonstrates secure, scalable logging using:

- AWS Lambda (Python)
- DynamoDB
- API Gateway
- Terraform

---

## 📌 Features

- ✅ Submit log entries via HTTP POST
- ✅ Retrieve the 100 most recent logs via HTTP GET
- ✅ Logs stored with UUID, timestamp, severity level, and message
- ✅ Fully IaC driven with a single `main.tf` file
- ✅ No UI required — testable via curl or Postman

---

## 📁 Project Structure

GG-Log-Service/
├── terraform/
│ └── main.tf # Full infrastructure definition
├── functions/
│ ├── submit_log/
│ │ └── handler.py # Lambda: store log entry
│ └── get_logs/
│ └── handler.py # Lambda: retrieve logs
├── submit_log.zip # Zipped Lambda package
├── get_logs.zip # Zipped Lambda package
├── GG-Log-Service.postman_collection.json
├── GG-Log-Service.postman_environment.json
└── README.md


---

## 🚀 Deployment Steps

### 1. Prerequisites

- AWS CLI installed and configured
- Terraform installed
- AWS IAM permissions to deploy Lambda, API Gateway, DynamoDB

---

### 2. Package Lambda Functions

From project root:

```bash
cd functions/submit_log
zip -r ../../submit_log.zip handler.py

cd ../get_logs
zip -r ../../get_logs.zip handler.py

cd terraform
terraform init
terraform apply

 This creates:

DynamoDB table

IAM role + policies

Two Lambda functions

API Gateway with /submit and /logs endpoints

Note: Terraform outputs the URLs for testing.

PI Endpoints
Assume https://abc123.execute-api.us-east-1.amazonaws.com/prod is your base URL.

🔹 1. Submit a Log Entry
Endpoint: POST /submit
Headers: Content-Type: application/json

{
  "severity": "warning",
  "message": "CPU usage is high"
}

curl -X POST https://<your-url>/submit \
  -H "Content-Type: application/json" \
  -d '{"severity": "info", "message": "Hello from curl"}'

 Get the 100 Most Recent Logs
Endpoint: GET /logs

curl https://<your-url>/logs

Response:

[
  {
    "id": "uuid",
    "datetime": "2025-06-17T17:10:00Z",
    "severity": "info",
    "message": "Hello from curl"
  }
]

🧪 Testing with Postman
Use the provided files:

GG-Log-Service.postman_collection.json

GG-Log-Service.postman_environment.json

Steps:

Import both files into Postman

Update the base_url in environment to your deployed API URL

Use the Submit Log and Get Logs requests to test

🛡️ Security & Best Practices
✅ Least privilege IAM roles

✅ Encrypted DynamoDB storage

✅ No hardcoded secrets

✅ Serverless, event-driven architecture

📘 Notes
Written in Python 3.11 for AWS Lambda

Logs are sorted by datetime descending

Fully IaC for repeatable deployment

👤 Author
Martin Botha
Cloud Engineer | DevOps Enthusiast
GitHub: Marty4FromCPT