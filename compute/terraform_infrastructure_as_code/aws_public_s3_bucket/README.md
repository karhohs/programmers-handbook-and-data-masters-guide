Terraform files are grouped in separate folders, because by default terraform will execute all `*.tf` files in a folder when run.

Running the bash script `run.sh` will create a bucket that is public facing with read-only access. The script will also upload files from the host system to the newly created bucket.

The bucket has been configured to prevent destruction. Therefore, terraform is unable to destroy the bucket after it has been created. The bucket must be destroyed manually through the AWS console.
