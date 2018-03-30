# aws_public_s3_bucket.tf
Creates a bucket that is public-facing for read-only access. Configures the module at *github.com/karhohs/programmers-handbook-and-data-masters-guide/compute/terraform_modules/aws_public_s3_bucket*.

# output.tf
Provides the name of the bucket that is being created.

# terraform_backend_s3.tf
The state file for the new bucket will be stored remotely in the bucket referenced in *terraform_backend_s3.tf*.
