#!/bin/bash

if [ -z $1 ]; then
  echo "Insert tag using Container Syntax. container-name:version"
  read -p " --> "
fi

echo " --- $(date) - Building APP ---"
docker build -t $1 ../.


