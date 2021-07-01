#######################################################
# Basic info: 
data "aws_caller_identity" "current" {}
locals {
  team                = "infra"
  subteam             = "sre"
  email_contact       = "noreply@arglabs.org"
  app_name            = "deep-thought"
  repository          = "https://github.com/ARGLabs/arglabs-infra-deep-thought"
  environment         = terraform.workspace
  deployer_account_id = data.aws_caller_identity.current.account_id
  deployer_user_id    = data.aws_caller_identity.current.user_id
  internal_dns_zone   = "infra.arglabs"
  region              = var.region[terraform.workspace]

  # Env vars that have defaults:
  budget_limit     = try(var.budget_limit[terraform.workspace], var.budget_limit.default)
  budget_threshold = try(var.budget_threshold[terraform.workspace], var.budget_threshold.default)

  # Provider Tags (to add tags even if we forget to put them on resources):
  provider_tags = {
    terraform           = "true"
    team                = local.team
    subteam             = local.subteam
    app_name            = local.app_name
    repository          = local.repository
    environment         = local.environment
    email_contact       = local.email_contact
  }
  # Additional tags that doesnt work as provider tags
  tags = {
    deployer_account_id = local.deployer_account_id
    deployer_user_id    = local.deployer_user_id
  }
}

# Team budget:
variable "budget_limit" { default = { default = "10.0", dev = "75.0", stg = "10.0", prd = "100.0" } }
variable "budget_threshold" { default = { default = "80" } }


#######################################################
# Outputs:
output "team" { value = local.team }
output "subteam" { value = local.subteam }
output "provider_tags" { value = local.provider_tags }
output "tags" { value = local.tags }
output "deployer_account_id" { value = local.deployer_account_id }
output "deployer_user_id" { value = local.deployer_user_id }
output "internal_dns_zone" { value = local.internal_dns_zone }
output "email_contact" { value = local.email_contact }

#######################################################
# AWS info: 
variable "region" { 
  default = { dev = "us-east-2"
              stg = "us-east-2" 
              prd = "us-east-2" } 
}
output   "region" { value = var.region[terraform.workspace] }

variable "azcount" { 
  default = { dev = "2"
              stg = "2"
              prd = "2" }
}
output   "azcount" { value = var.azcount[terraform.workspace] }

variable "azs" { 
  default = { dev = [ "us-east-2a", "us-east-2c" ]
              stg = [ "us-east-2a", "us-east-2c" ] 
              prd = [ "us-east-2a", "us-east-2c" ] 
  }
}
output   "azs" { value = var.azs[terraform.workspace] }

#######################################################
# Network configuration for this team: 
variable "arglabs_cidr_block" { 
  default = { dev = "10.255.0.0/16"
              stg = "10.254.0.0/16"
              prd = "10.0.0.0/16" }
}
output   "arglabs_cidr_block" { value = var.arglabs_cidr_block[terraform.workspace] }

variable "vpc_cidr_block" { 
  default = { dev = "10.255.0.0/24"
              stg = "10.254.0.0/24"
              prd = "10.0.0.0/24" }
}
output   "vpc_cidr_block" { value = var.vpc_cidr_block[terraform.workspace] }

# Public subnets:
variable "public_subnet_cidr_block" { 
  type = map
  default = { dev = [ "10.255.0.128/26", "10.255.0.192/26" ]   # 10.255.0.128/25
              stg = [ "10.254.0.128/26", "10.254.0.192/26" ]   # 10.254.0.128/25
              prd = [ "10.0.0.128/26"  , "10.0.0.192/26"   ] } # 10.0.0.128/25
}
output   "public_subnet_cidr_block" { value = var.public_subnet_cidr_block[terraform.workspace] }

# Private subnets:
variable "private_subnet_cidr_block" { 
  type = map
  default = { dev = [ "10.255.0.0/26", "10.255.0.64/26" ]   # 10.255.0.0/25 
              stg = [ "10.254.0.0/26", "10.254.0.64/26" ]   # 10.254.0.0/25
              prd = [ "10.0.0.0/26"  , "10.0.0.64/26"   ] } # 10.0.0.0/25
}
output   "private_subnet_cidr_block" { value = var.private_subnet_cidr_block[terraform.workspace] }


