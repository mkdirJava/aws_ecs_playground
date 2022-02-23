# Playground for ECS terraform deployment and app development


## How to run?

Requirements

- Terraform installed
- Docker installed 
- AWS cli setup

Limitations

- Currently this is set to deploy to eu-west2 (London)
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
1. Install dependencies locally
2. Dockerise it to an image
3. Push to a the aws ECR 
4. Deploy and ECS cluster
5. Deploy the image to a container running in the ECS cluster
6. Create a ./destroy.sh 
7. The ECS cluster is made of EC2 t3.micro instances, As this is in  the default VPC it is publically accessable, you should be able to do the curls below on an EC2 instance

To do a tear down 
run ./destroy

---
## The application
The application is a nodejs express app

```
curl <host>:7070/data
```
Will retrieve all data of IP to data posted below

```
curl -X POST <host>:7070/data -d home
```
Will assosaite the data payload with the IP

----------------------

