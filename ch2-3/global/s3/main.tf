# Terraform Config

terraform {
  backend "s3" {
    bucket   = "vv-unique-and-cool-bucket-name"
    key      = "global/s3/terraform.tfstate"
    region   = "us-east-1"
    encrypt  = true
  }
}


# Provider 

provider "aws" {
    region = "us-east-1"
}

# Resources

resource "aws_s3_bucket" "terraform_state" {
    bucket = "vv-unique-and-cool-bucket-name"
    
    versioning {
        enabled = true
    }
    
    lifecycle {
        prevent_destroy = true
    }
}
