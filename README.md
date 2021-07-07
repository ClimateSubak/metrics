# Subak Key Metrics App

## Description

Flask app, calling data from Airtable on a schedule, displaying it in range of text and visual components  
Dockerised, deployed to AWS ECR, with a task definition that serves image tagged 'latest' in ECS with a load balancer  
See `main.tf` for infra

## Todo
- [ ] Get data
- [ ] tabs
- [ ] make components

## Testing
Build docker image  
`docker buildx build --platform linux/amd64 -t aws-terraform-metrics/runner . --load`  
Run docker image locally  
`docker run -p 5000:5000 aws-terraform-metrics/runner:latest`  

## Deployment
Deployment Script  
`./push.sh . 848094190915.dkr.ecr.eu-west-2.amazonaws.com/aws-terraform-metrics/runner latest 848094190915`  

Or

Build docker image  
`docker buildx build --platform linux/amd64 -t aws-terraform-metrics/runner . --load`  
Tag docker image  
`docker tag aws-terraform-metrics/runner:latest 848094190915.dkr.ecr.eu-west-2.amazonaws.com/aws-terraform-metrics/runner:latest`  
Login to ECR  
`aws --region "$region" ecr get-login-password | docker login --username AWS --password-stdin 848094190915.dkr.ecr.eu-west-2.amazonaws.com`  
Push docker image  
`docker push 848094190915.dkr.ecr.eu-west-2.amazonaws.com/aws-terraform-metrics/runner:latest`  
Then force an update on ECS to use the new image
`aws ecs update-service --cluster aws-terraform-metrics-cluster --service aws-terraform-metrics-service --force-new-deployment`


## Create infrastructure
Keep secrets in `terraform.tfvars`, these are loaded automatically by terraform.  
Check what will be created/changed  
`terraform plan`  
Apply changes  
`terraform apply`  