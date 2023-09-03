terraform {
  required_providers {
    prismacloud = {
      source = "PaloAltoNetworks/prismacloud"
      // version = "1.3.7"
    }
  }
}

provider "prismacloud" {
    url= var.pcs-url
    username= var.pcs-username
    password= var.pcs-password
    # customer_name= var.pcs-tenant
    protocol= "https"
    port= "443"
    timeout= "90"
    skip_ssl_cert_verification= "true"
    # logging= "quiet"
    disable_reconnect= "false"
    json_web_token= ""
    json_config_file= ""
}

provider "aws" {
  region = "ap-southeast-1"
}

locals {
    instances = csvdecode(file("aws.csv"))
}

module "PrismaCloud-AWS-Onboarding" {
  source = "./pcs-aws-acc-onboard"
  for_each = { for inst in local.instances : inst.name => inst }

  account_id = each.value.accountId
  pcs-cloud-acc-name = each.value.name
  pcs-account-grp-name = var.pcs-account-grp-name
  aws_org_account_id = var.pcs-aws-mgmt-account-id
}

