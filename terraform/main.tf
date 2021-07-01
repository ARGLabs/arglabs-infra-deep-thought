# Providers:
provider "aws" {
  region = local.region
  default_tags { tags = local.provider_tags }
}

# Terraform:
terraform { 
  required_version = ">= 0.15"
  required_providers { aws = { version = ">= 3.36.0" } }
  backend "s3" {
    bucket    = "arglabs-terraform-states" 
    region    = "sa-east-1"
    key       = "sre/deep-thought.state"
  }
}


