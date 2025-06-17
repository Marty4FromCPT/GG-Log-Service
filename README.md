# GG Log Service

![Terraform CI](https://github.com/Marty4FromCPT/GG-Log-Service/actions/workflows/deploy.yml/badge.svg)








Project Folder Structure

GG-LOG-SERVICE/
├── .github/
│   └── workflows/
│       └── deploy.yml                   # ✅ GitHub Actions pipeline
│
├── functions/
│   ├── submit_log/
│   │   ├── handler.py
│   │   └── submit_log.zip               # (excluded from Git via .gitignore)
│   └── get_logs/
│       ├── handler.py
│       └── get_logs.zip                 # (excluded from Git via .gitignore)
│
├── terraform/
│   ├── main.tf                          # AWS provider setup
│   ├── variables.tf                     # Project variables
│   ├── outputs.tf                       # Output API endpoint
│   ├── dynamodb.tf                      # DynamoDB + KMS
│   ├── iam.tf                           # IAM roles and permissions
│   ├── lambda.tf                        # Lambda definitions
│   ├── api_gateway.tf                   # API Gateway configuration
│
├── .gitignore                           # Excludes .terraform/, *.zip, etc.
├── README.md                            # Project documentation





Step 1

Run the the following commands.
cd terraform
terraform init
Confirm Terraform initializes successfully!!

Step 2

Run the following commands.
terraform plan
terraform apply

Results
Sets up and pushed a clean repo (GG-LOG-SERVICE)
Applied Terraform and deployed AWS infrastructure (Lambda, DynamoDB, API Gateway)
Verified that your GitHub repo matches your local setup