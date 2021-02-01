# aws-api-terraform

Terraform scripts for AWS API

## Supported version

These scripts have been written using Terraform 0.13.1.

## Pre-requisites

If you want to deploy the AWS API into your own AWS environment, you need to have:

- Terraform (`brew install terraform`)
- Your AWS credentials stored in `~/.aws/credentials`
- Your profile needs to be called `default`

This script will deploy to eu-west-2 (London) by default.

## Secrets Required

If you are using these Terraform scripts to spin this up in your own AWS environment, you will need to create a tfvars file with the following entries:

```
database_password = "<YOUR_DB_PASSWORD>"
bastion_host_pubkey = "<YOUR_RSA_PUBKEY>"
hosted_zone_id = "<YOUR_HOSTED_ZONE_ID>"
hosted_zone_dns = "<YOUR_HOSTED_ZONE_DNS>"
swagger_ui_dns = "<YOUR_SWAGGER_UI_DNS>"
```

You can call it `your-name.tfvars` for instance.

_NOTE_: If you are not using AWS Route 53 for DNS in your domain,

- Do not add the `hosted_zone_id` and `hosted_zone_dns` entries in your tfvars file.
- Remove the variable `hosted_zone_id` and `hosted_zone_dns` from `./variables.tf`, `ecs/variables.tf` and `./main.tf`.
- Remove the `aws_route53_record` resource from `ecs/alb.tf`. Otherwise, things won't work.

## How to run

```
terraform plan -var-file="your-name.tfvars" -out=plan.out
terraform apply -var-file="your-name.tfvars" plan.out
```

Wait a while, and you're done. To see the adddress the microservice is deployed in, run

```
terraform output
```

## Bootstrap DB with basic data

SSH into your your bastion host and run the following commands:

```
sudo su
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-latest-x86_64/postgresql10-libs-10.7-2PGDG.rhel7.x86_64.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-latest-x86_64/postgresql10-10.7-2PGDG.rhel7.x86_64.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-latest-x86_64/postgresql10-server-10.7-2PGDG.rhel7.x86_64.rpm
psql -h <db_endpoint_from_terraform_output> -p 5432 -U postgres
# Enter your password when prompted
postgres=> create table db_user(username varchar(256), pw_hash varchar(2048), salt varchar(2048));
postgres=>create unique index idx2541054d on db_user(username);
postgres=> insert into db_user values('admin', '8Sw8nanvihUNOCyY1qOOxg587HwivE2MA+dgXyscACfbPx/jd6n9IEnhdPpyzDX/BWf+4odC3ozCCuCaui80AQ==', '6i69ttZEMjfa/10NfI29jQ==');
```

## TODO: Switch from Bastion hosts to SSM

I chose to spin up a Bastion host over using AWS Session Manager because I have no EC2 instances in the VPC to tunnel to the RDS from, and it seemed like a bit of a faff. :-)
