
terraform init
choice=$1
if [ $choice = "plan" ]
then
terraform plan

elif [ $choice = "apply" ]
terraform apply -auto-approve

elif [ $choice = "apply" ]
terraform destroy -auto-approve
fi
