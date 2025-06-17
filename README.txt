Project Folder Structure

GG-Log-Service/
├── functions/                         # Lambda function code
│   ├── submit_log/
│   │   ├── handler.py
│   │   └── submit_log.zip             # Zipped for Terraform deployment
│   └── get_logs/
│       ├── handler.py
│       └── get_logs.zip               # Zipped for Terraform deployment
│
├── terraform/                         # Infrastructure-as-Code
│   ├── main.tf                        # AWS provider
│   ├── variables.tf                   # Variables used in the setup
│   ├── outputs.tf                     # Outputs like API Gateway URL
│   ├── dynamodb.tf                    # DynamoDB + KMS setup
│   ├── iam.tf                         # IAM roles for Lambda access
│   ├── lambda.tf                      # Lambda function definitions
│   ├── api_gateway.tf                 # API Gateway config + routes
│
├── .github/
│   └── workflows/
│       └── deploy.yml                 # GitHub Actions CI/CD pipeline
│
├── .gitignore                         # Optional: ignore .zip, .terraform, etc.
├── README.md                          # Full documentation (step-by-step)



Full Terraform File Set:
main.tf – Provider config
variables.tf – Inputs
dynamodb.tf – Log storage
iam.tf – Roles + policies for both Lambda functions
lambda.tf – Function packaging + deployment (with submit_log and get_logs)
api_gateway.tf – API Gateway + routing
outputs.tf – API endpoint outputs


Step 1

Run the the following commands.
cd terraform
terraform init
Confirm Terraform initializes successfully!!

Step 2

Run the following commands.
terraform plan
terraform apply

Step 3: Add Python Lambda Functions


Checklist Before You Run apply
Your submit_log.zip and get_logs.zip files are created and valid.

Terraform points to the correct .zip paths in lambda.tf.

You’ve already run terraform init and terraform plan with no errors.

Once apply is done, Terraform will print your API Gateway endpoint from outputs.tf.

Let me know if you want to test the API or move to Step 4: CI/CD automation!