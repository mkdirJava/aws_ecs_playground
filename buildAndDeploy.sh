#!/bin/bash
set -e

ecr=$1
if [ -z ${ecr} ]; then
    echo "Need to add use an ECR, please run ./deployECR.sh"
    exit 0
fi

terraform -chdir=./deployment init
buildDateTime=$(date '+%d_%m_%Y_%H_%M')
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $ecr
docker build -t ecr_practice_service:$buildDateTime ./app 
docker tag ecr_practice_service:$buildDateTime $ecr:$buildDateTime
docker push $ecr:$buildDateTime

terraform -chdir=./deployment apply -var='service={"service_name"="service_one","image"="'$ecr:$buildDateTime'","port"=7070}'

cat << EOF > ./destroy.sh 
#!/bin/bash
terraform -chdir=./deployment destroy -var='service={"service_name"="service_one","image"="'$ecr:$buildDateTime'","port"=7070}' -auto-approve
terraform -chdir=./deployment/modules/ECR destroy -auto-approve
EOF
