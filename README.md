📘 GG-Log-Service

A serverless, infrastructure-as-code driven log service application using AWS Lambda, DynamoDB, API Gateway, and Terraform. This solution enables log ingestion and retrieval via secure RESTful API endpoints.

Features

Two AWS Lambda functions:

submit-log-function: Accepts and stores logs
get-logs-function: Retrieves the 100 most recent logs
DynamoDB with encryption enabled
Least privilege IAM roles
Fully IAC-managed using Terraform
GitHub Actions pipeline to update Lambda code (optional)




🔷 STEP 1: Clone This Repository

git clone https://github.com/Marty4FromCPT/GG-Log-Service.git
cd GG-Log-Service




🔷 STEP 2: AWS Setup

Configure AWS CLI

If you haven’t already, configure your AWS credentials:

cmd - aws configure

Provide:
AWS Access Key ID
AWS Secret Access Key
Default region: us-east-1




🔷 STEP 3: Deploy Infrastructure Using Terraform

All infrastructure is defined in a single terraform/main.tf file.

cd terraform/
terraform init/
terraform apply

Outputs:

You’ll receive two API Gateway URLs:

- submit_log_url  (to POST logs)
- get_logs_url    (to GET the latest 100 logs)


Lambda Zip Files Already Included 

pre-zipped files (submit_log.zip and get_logs.zip) are already included in the functions/ directory.



🔷 STEP 4: Test the API with curl

🔹 Submit log entries with provided submit_logs.sh script in functions/ directory   (# Replace <api-url> with your actual API Gateway URL in script)

   run - bash submit_logs.sh

   Once exectuted run below command for log retrieval.

🔹 Gets the lates 100 Log entries (most recent to first ) with below command.
# Replace <api-url> with your actual API Gateway URL
curl -s https://<api-id>.execute-api.us-east-1.amazonaws.com/prod/logs | jq .




🔐 Security & Best Practices

DynamoDB is encrypted using AWS-managed KMS
Lambda roles follow least privilege
IAM permissions scoped tightly to required actions
No credentials exposed in repo




Built and tested by Martin Botha · Powered by AWS + Terraform ☁️
