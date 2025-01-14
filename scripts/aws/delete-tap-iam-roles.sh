#!/usr/bin/env bash

set -eo pipefail

# Delete previously created IAM roles required for installing Tanzu Application Platform on AWS EKS integrating with ECR

# This script is based off policy documents described in https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/aws-resources.html#create-iam-roles-5.
# Use it to remove roles created by create-tap-iam-roles.sh.

if [ -z "$1" ] && [ -z "$2" ]; then
	echo "Usage: delete-tap-iam-roles.sh {eks-cluster-name} {aws-region}"
	exit 1
fi

set -x
CLUSTER_NAME_CONTAINS="$1"

export AWS_REGION="$2"
export EKS_CLUSTER_NAME=$(aws eks list-clusters --region ${AWS_REGION} --query 'clusters[?contains(@, `${CLUSTER_NAME_CONTAINS}`)]' | sed -n '2p' | tr -d '"' | awk '{gsub(/^ +| +$/,"")} {print $0}')
set +x

if [ -z "$EKS_CLUSTER_NAME" ]; then
  echo "No cluster found matching id containing $CLUSTER_NAME_CONTAINS"
  exit 1
fi

# Check to see if tap-build-service role for cluster already exists
aws iam get-role --role-name tap-build-service-for-$EKS_CLUSTER_NAME
if [ $? -eq 0 ]; then
  # Delete the Tanzu Build Service Role
  aws iam delete-role-policy --role-name tap-build-service-for-$EKS_CLUSTER_NAME --policy-name tapBuildServicePolicy
  aws iam delete-role --role-name tap-build-service-for-$EKS_CLUSTER_NAME
else
  echo "IAM role named [ tap-build-service-for-$EKS_CLUSTER_NAME ] does not exist!"
fi

# Check to see if tap-workload role for cluster already exists
aws iam get-role --role-name tap-workload-for-$EKS_CLUSTER_NAME
if [ $? -eq 0 ]; then
  # Delete the Workload Role
  aws iam delete-role-policy --role-name tap-workload-for-$EKS_CLUSTER_NAME --policy-name tapWorkload
  aws iam delete-role --role-name tap-workload-for-$EKS_CLUSTER_NAME
else
  echo "IAM role named [ tap-workload-for-$EKS_CLUSTER_NAME ] does not exist!"
fi
