#!/bin/bash

# TAG: measurement-app:1.1
echo " --- $(date) - Delete measurement-app container ---"
docker rm -f measurement-app

echo " --- $(date) - Building APP ---"
docker build -t $1 ../.

echo ""
echo " --- $(date) - Starting APP ---"
docker run --name=measurement-app -d -p5000:5000 -e DB_URI="postgresql://postgres:mysecretpassword@192.168.87.10:5432/environment_airq_measurand" $1

