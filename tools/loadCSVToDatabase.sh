#!/bin/bash

docker exec -ti postgres psql -d environment_airq_measurand -U postgres -c "\copy environment_airq_measurand(timestamp,id_entity,so2,no2,co,o3,pm10,pm2_5) from '/tmp/environment_airq_measurand.csv' with csv"


