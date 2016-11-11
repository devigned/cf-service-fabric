# Service Fabric Cloud Formation Recipe
This project contains an AWS Cloud Formation recipe which will
provision an auto-scaling group containing a Service Fabric cluster.

## Getting Started
- install awscli
- add your public key to AWS "Key Pairs" on the EC2 dashboard
- clone the repository
- `cd` into the cloned repository
- run `aws cloudformation create-stack --stack-name foo-stack --template-body file://./service-fabric-cluster.yaml --parameters ParameterKey=KeyName,ParameterValue=your_key_name --capabilities CAPABILITY_IAM`

The above steps should start a deployment of 5 machines within an auto-scale
group.

## Tearing Down
- run `aws cloudformation delete-stack --stack-name foo-stack`

## Recipe Parameters
The recipe picks sane defaults, but you may want to tweak them to fit 
your specific needs.

- KeyName (**required**)
    - Name of an existing EC2 KeyPair to enable SSH access to the Service Fabric Cluster
- DiskType (default: ssd enabled ebs)
    - Type of disk that will be backing the cluster instances
    - AllowedValues:
        - ephemeral
        - ebs
- SFClusterSize (default: 5)
    - Number of nodes in the Service Fabric cluster
- SFInstanceType (default: m4.large)
    - Type of EC2 instance for Service Fabric
    - AllowedValues:
        - m4.large
        - m4.xlarge
        - m4.2xlarge
        - m4.4xlarge
        - c4.large
        - c4.xlarge
        - c4.2xlarge
