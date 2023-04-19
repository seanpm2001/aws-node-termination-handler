#!/bin/bash
set -euo pipefail

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
REPO_NAME="helm/aws-node-termination-handler-2"
REPO_ROOT_PATH=$SCRIPTPATH/../
TEMPLATE_PATH=$REPO_ROOT_PATH/scripts/ecr-template-for-helm-chart.json
CATALOG_DATA=$(cat "$TEMPLATE_PATH")

if aws ecr-public describe-repositories --region us-east-1 --repository-names "$REPO_NAME" > /dev/null 2>&1; then
    echo "The repository $REPO_NAME exists, update it with template..."
    aws ecr-public put-repository-catalog-data --region us-east-1 --repository-name "$REPO_NAME" --catalog-data "$CATALOG_DATA"
else
    echo "The repository $REPO_NAME does not exist, create it with template..."
    aws ecr-public create-repository --region us-east-1 --repository-name "$REPO_NAME" --catalog-data "$CATALOG_DATA"
fi