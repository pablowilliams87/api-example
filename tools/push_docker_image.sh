#!/bin/bash

docker tag $2 $1/$2

docker login

docker push $1/$2

