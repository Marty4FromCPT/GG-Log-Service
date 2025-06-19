Project Summary – GG Log Service

I developed a fully serverless, infrastructure-as-code (IaC) log service using AWS Lambda, API Gateway, DynamoDB, and Terraform. The solution includes:

Two Lambda functions:
One to receive and store log entries
One to retrieve the latest 100 logs, sorted by timestamp
API Gateway endpoints to interact with the service
DynamoDB as the storage layer, with AWS-managed KMS encryption
Least privilege IAM roles for secure execution
All infrastructure is provisioned via Terraform in a single file
A clean README with testing instructions and curl/Postman examples
A test script (submit_logs.sh) to simulate log traffic
Optionally includes a GitHub Actions pipeline to update Lambda code
The entire setup is repeatable, secure, and easy to deploy, with no manual steps after cloning the repository and configuring AWS credentials.



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
   
🔹 Use below commands to create 200 log entries. (Wait to completed and move to next step for message retreival status)
   RUN
   chmod +x submit_logs.sh
   ./submit_logs.sh


🔹 Below command gets the lates 100 Log entries (most recent to first )
RUN
# Replace <api-url> with your actual API Gateway URL
curl -s https://<api-id>.execute-api.us-east-1.amazonaws.com/prod/logs | jq .




Security & Best Practices

DynamoDB is encrypted using AWS-managed KMS
Lambda roles follow least privilege
IAM permissions scoped tightly to required actions
No credentials exposed in repo

General Requirements
Requirement	 Status
Language of your choice	- Python
Well-documented code	- Clear handlers + README
GitHub repo	- Repo is live and up to date
Pipeline to deploy Lambda code - GitHub Actions configured (OIDC role assumed)
Least privilege IAM	- Role allows only necessary actions
Data encryption - DynamoDB uses AWS-managed KMS
No exposed credentials	- AWS CLI with aws configure or GitHub OIDC
Secure pipeline authentication - GitHub OIDC role + configure-aws-credentials action
API security considered	- IAM + HTTP headers; could later add auth if required


Built and tested by Martin Botha · Create with AWS + Terraform 
