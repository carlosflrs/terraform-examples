# Outputs

output "s3_bucket_arn" {
    value = "${aws_s3_bucket.terraform_state.arn}"
}

output "elb_dns_name" {
    value = "${module.webserver_cluster.elb_dns_name}"
}
