# Measurement APP
## API
Measurement-app is an API written in Python, It uses SQLAlchemy as ORM to connect to Postgres Database. The API exposes the endpoint /air_quality to generate air quality measurements csv.

### App
```
app/
 |--> app.py --> Main code
 |--> models.py --> Object modeler
 |--> requirements.txt --> Python requirements
```

### Tools
```
tools/
 |--> build_docker_image.sh
 |--> 
 |--> 
```

### Docker

#### Build Docker Image
```bash
cd tools
./build_docker_image.sh <TAG>

Example: ./build_docker_image.sh measurement-app:1.1
```

#### Run Docker Image
```bash
docker run -d --name measurement-app -p 5000:5000 -e DB_URI=<postgres-db-uri> <image>
```

- `DB_URI` is an envvar that define postgres URI to connect to database. Example
```bash
DB_URI=postgresql://postgres:P0stgr3s@192.168.87.10:5432/environment_airq_measurand
```

#### Database
Not having a Postgres DB to test, the following command create a postgres container
```bash
# Ephemeral postgres (Caution!! postgres data is not persistent)
docker run --name postgres-test -p 5432:5432 -e POSTGRES_PASSWORD=P0stgr3s -d postgres 

# Persistent postgres
docker run --name postgres-test -p 5432:5432 -e POSTGRES_PASSWORD=P0stgr3s -v /datafiles/database/postgres:/var/lib/postgresql/data -d postgres 
```

#### Load Measurement data on DB
To create and Load DB
```bash
docker exec -ti measurement-app flask initdb
```

#### Test App
```bash
curl http://localhost:5000/air_quality
```


### Docker Compose

#### Deploy Compose
```bash
docker-compose up --build -d
```

#### [First Run] InitDB
```
docker exec -ti api-example_api_1 flask initdb
```

#### Delete Compose
```bash
docker-compose down
```

## CI (Continuous Integration)
### Infrastructure
Cloud Provider: Amazon

![alt text](infrastructure/ecs_infra.png)


### CI
To implement CI I choose GitHub Actions because is a tool that 
