#!/bin/bash
#
# Builds a Docker image and pushes to an AWS ECR repository

# name of the file - push.sh

set -e

source_path="$1" # 1st argument from command line
repository_url="$2" # 2nd argument from command line
tag="${3:-latest}" # Checks if 3rd argument exists, if not, use "latest"
userid="$4"

# splits string using '.' and picks 4th item
region="$(echo "$repository_url" | cut -d. -f4)"

# splits string using '/' and picks 2nd item
image_name="$(echo "$repository_url" | cut -d/ -f2)"

# builds docker image
# uses buildkit and multi-arch builds to build on mac m1 arm, for ECS amd64 arch
(cd "$source_path" && DOCKER_BUILDKIT=1 docker buildx build --platform linux/amd64 -t "$image_name" . --load)

# login to ecr
aws --region "$region" ecr get-login-password | docker login --username AWS --password-stdin ${userid}.dkr.ecr.eu-west-2.amazonaws.com

#$(aws ecr get-login-password --region "$region")

# tag image
docker tag "$image_name" "$repository_url":"$tag"

# push image
docker push "$repository_url":"$tag"

# Update ECS
aws ecs update-service --cluster aws-terraform-metrics-cluster --service aws-terraform-metrics-service --force-new-deployment