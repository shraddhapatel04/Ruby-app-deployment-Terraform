# Ruby-app-deployment-Terraform
Deploying a Ruby on Rails Application on AWS using Terraform

## Step 1: Create a public private key pair using ssh keygen that would be used to launch the ec2 instances
ssh-keygen -t rsa

## Step 2: Get into the terraform folder and open the terraform.tfvars file
cd terraform
vi terraform.tfvars

Edit the terraform.tfvars files replacing the variables as needed

## Step 3: Run terraform plan to check the resources being created
terraform plan

## Step 4: If the plan stage looks fine run terraform applyto create the resources
terraform apply --auto-approve

## Step 5: Finally if not required clean the infrastructure using terraform destroy 
terraform destroy --auto-approve
