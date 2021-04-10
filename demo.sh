
terraform init
choice=$1
if [ $choice = "plan" ]
then
terraform plan

elif [ $choice = "apply" ]
then
terraform apply -auto-approve

elif [ $choice = "apply" ]
then
terraform destroy -auto-approve
fi
