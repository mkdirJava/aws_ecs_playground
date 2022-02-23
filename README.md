# Playground for ECS terraform deployment and app development


## How to run?

Requirements

- Docker installed 
- aws cli setup

Limitations

- Currently this is set to deploy to eu-west2 (Longdon)
- There is hard set configurations to only allow one service to be configured
- The ECS cluster is deployed to the default VPC 
- It allows for all traffic !!!! DO NOT RUN THIS FOR EXTENTED PERIODS OF TIME


First setup a aws image registry using 

```
<project root>/.deployECR.sh
```
This should give you a registry URL needed for the next command below
The run 
```
<project root>/buildAndDeploy.sh <ECR registry URL>
```
The buildAndDeploy script will
1. build the application 
2. Dockerise it to an image
3. Push to a the aws ECR 
4. Deploy and ECS cluster
5. Deploy the image to a container running in the ECS cluster
6. Create a ./destroy.sh 

To do a tear down 
run ./destroy



----------------------

