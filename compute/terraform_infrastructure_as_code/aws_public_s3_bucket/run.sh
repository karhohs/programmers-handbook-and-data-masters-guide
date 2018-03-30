source /home/ubuntu/variables.sh

cd tf_aws_public_s3_bucket

terraform get -update 

terraform init -force-copy

terraform plan -detailed-exitcode

output=`echo $?`

if [ "$output" -eq 1 ]; then
    echo "Error."

else
    terraform apply

fi

BUCKET=$(terraform output id)

aws s3 cp --recursive --dryrun "${FILEDIR}" "s3://${BUCKET}/"

cd ..