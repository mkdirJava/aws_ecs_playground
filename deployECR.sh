#!/bin/bash
terraform -chdir=./deployment/modules/ECR init
terraform -chdir=./deployment/modules/ECR apply

