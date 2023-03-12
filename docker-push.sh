#!/bin/bash
commit_hash=$(git rev-parse --short HEAD)
docker build . -t ajoel24/jenkins:temp || exit
docker tag ajoel24/jenkins:temp ajoel24/jenkins:$commit_hash
docker push ajoel24/jenkins:$commit_hash
docker tag ajoel24/jenkins:temp ajoel24/jenkins:latest
docker push ajoel24/jenkins:latest
