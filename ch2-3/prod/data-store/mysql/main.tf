# Terraform Config

terraform {
  backend "s3" {
    bucket   = "vv-unique-and-cool-bucket-name"
    key      = "prod/data-stores/terraform.tfstate"
    region   = "us-east-1"
    encrypt  = true
  }
}


# Provider

provider "aws" {
    region = "us-east-1"
}


# Resources

resource "aws_db_instance" "example" {
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "example_database"
  username          = "admin"
  password          = "${var.db_password}"
}
