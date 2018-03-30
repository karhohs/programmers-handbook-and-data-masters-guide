resource "aws_s3_bucket" "b" {

  acl = "public-read"

  bucket_prefix = "${var.bucket_prefix}"

  lifecycle {

    prevent_destroy = true

  }

  region = "${var.region}"

  tags {

    Name = "${var.bucket_prefix}"

  }

}
