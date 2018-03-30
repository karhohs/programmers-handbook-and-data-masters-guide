module "aws_public_s3_bucket" {

  bucket_prefix = "my-bucket"

  region = "us-east-1"

  source = "github.com/karhohs/programmers-handbook-and-data-masters-guide/compute/terraform_modules/aws_public_s3_bucket"

}
