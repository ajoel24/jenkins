#!/bin/bash
docker build . -t ajoel24/jenkins:temp || exit
docker tag ajoel24/jenkins:temp ajoel24/jenkins:$1
docker push ajoel24/jenkins:$1
docker tag ajoel24/jenkins:temp ajoel24/jenkins:latest
docker push ajoel24/jenkins:latest
