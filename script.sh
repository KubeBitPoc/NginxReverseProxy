#!/bin/bash

echo "Building the docker image"
docker build -t anilbb/webapp-proxy:latest .

echo "Pushing the docker image to the docker repository"
docker push anilbb/webapp-proxy:latest


echo "Deleting the current frontend-deployment"
kubectl delete deployment frontend-deployment

if [ $? -eq 1 ]; then
continue;
fi


echo "Creating the frontend-deployment"
kubectl create -f frontend-deployment.yaml


