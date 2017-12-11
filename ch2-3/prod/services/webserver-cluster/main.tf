# Terraform Config

terraform {
  backend "s3" {
    bucket   = "vv-unique-and-cool-bucket-name"
    key      = "prod/services/webserver-cluster/terraform.tfstate"
    region   = "us-east-1"
    encrypt  = true
  }
}


# Provider

provider "aws" {
    region = "us-east-1"
}


# Modules
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster/"

  cluster_name = "webservers-stage"

  db_remote_state_bucket   = "vv-unique-and-cool-bucket-name"
  db_remote_state_key      = "prod/data-stores/terraform.tfstate"

  min_size      = 1
  max_size      = 2
  instance_type = "t2.micro"
}


# Resources
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-ours"
  min_size         = 1
  max_size         = 2
  desired_capacity = 2
  recurrence       = "0 9 * * *"

  autoscaling_group_name = "${module.webserver_cluster.asg_name}"
}


resource "aws_autoscaling_schedule" "scale_in_during_business_hours" {
  scheduled_action_name = "scale-in-during-business-ours"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  recurrence       = "0 17 * * *"


  autoscaling_group_name = "${module.webserver_cluster.asg_name}"
}
