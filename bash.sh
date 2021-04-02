#!/bin/bash
set -eo pipefail
exit_status=0
terraform init -reconfigure
terraform validate
terraform plan -detailed-exitcode || exit_status=$?
if [ $exit_status -eq 0 ]; then
    echo "No changes, not applying"
elif [ $exit_status -eq 1 ]; then
    echo "Terraform plan failed"
    exit 1
elif [ $exit_status -eq 2 ]; then
    if [[ $ACTION == "APPLY" ]]; then
        terraform apply -auto-approve
    fi
fi

