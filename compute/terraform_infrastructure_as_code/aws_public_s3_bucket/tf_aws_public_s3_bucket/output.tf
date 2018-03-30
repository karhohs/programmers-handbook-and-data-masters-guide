output "id" {

  value = "${module.aws_public_s3_bucket.id}"

}

output "bucket_domain_name" {

  value = "${module.aws_public_s3_bucket.bucket_domain_name}"

}
