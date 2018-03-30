terraform {

  backend "s3" {

    bucket = "imaging-platform-terraform-remote-backend"

    key    = "aws_public_s3_bucket/aws_run_cellprofiler/terraform.tfstate"

    region = "us-east-1"

  }

}
