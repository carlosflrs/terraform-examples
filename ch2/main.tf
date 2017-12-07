# Terraform Config

terraform {
  backend "s3" {
    bucket   = "vv-unique-and-cool-bucket-name"
    key      = "global/s3/terraform.tfstate"
    region   = "us-east-1"
    encrypt  = true
    # For state locking
    dynamodb_table = "terraform-state-locking-table"
  }
}


# Provider 

provider "aws" {
    region = "us-east-1"
}


# Variables

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    default = 8080
}


# Outputs

output "s3_bucket_arn" {
    value = "${aws_s3_bucket.terraform_state.arn}"
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

resource "aws_dynamodb_table" "locking_table" {
    name           = "terraform-state-locking-table"
    read_capacity  = 1
    write_capacity = 1
    hash_key       = "LockID"
    
    attribute {
      name = "LockID"
      type = "S"
    }

}

resource "aws_instance" "example" {    
  ami           = "ami-40d28157"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  tags {
    Name = "terraform-example"
    }   
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    
    ingress {
        from_port   = "${var.server_port}"
        to_port     = "${var.server_port}"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}
