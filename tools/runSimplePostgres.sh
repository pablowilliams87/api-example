#!/bin/bash

docker run -d --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -e PGDATA=/var/lib/postgresql/data/pgdata -v /datafiles/database/postgresql:/var/lib/postgresql/data postgres 

