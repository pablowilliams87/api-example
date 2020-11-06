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
# Option 1: Ephemeral postgres (Caution!! postgres data is not persistent)
docker run --name postgres-test -p 5432:5432 -e POSTGRES_PASSWORD=P0stgr3s -d postgres 

# Option 2: Persistent postgres
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
*Cloud Provider*: Amazon

![infra](infrastructure/ecs_infra.png)

On AWS I have 1 VPC with 3 differents ECS Cluster
- Production
- Staging
- Development

Each Cluster has its own subnet for IP traffic segmentation, this also allows us to implement network ACLs to improve app security. The infrastructure includes the creation of public and private subnets.

About databases, production environment uses Aurora Postgres because It is scalable, easy to operate automating administrative tasks like backups and patching, and it has Multi-AZ redundancy that permit us to improve platform availability. Staging environment is similar to Production with less resources, It uses Aurora Postgres to has similar Production services. Development environment uses RDS Postgresql because Multi-AZ redundancy is not needed. 

All environments have an Application Load Balancer as ingress, Production has an Autoscaling Group with 4 instances as desired state (scale to 8 to duplicate its processing), Staging has 2 instances (Scaling to 4) and Development 1 instance.

Infrastructure uses Route53 alias to route to Application Load Balancer endpoint.



### CI

To implement CI I choose GitHub Actions because is fully integrated with Github and does not require and external server/agent. To use it I have created GitHub actions pipelines in .github/workflows folder. Login to AWS account is through secrets configuration on GitHub account, once configured, they are instantiated from the pipeline
```
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
```

This project has the following pipelines
- A pull request to the main branch generates a Docker images, the image is pushes to AWS ECR and then it is deployed to Production ECS.
[branch_production_pull_request.yml](.github/workflows/branch_production_pull_request.yml) 

- A pull request to the staging branch generates a Docker images, the image is pushes to AWS ECR and then it is deployed to Staging ECS.
[branch_staging_pull_request.yml](.github/workflows/branch_staging_pull_request.yml)

- A pull request to the development branch generates a Docker images, the image is pushes to AWS ECR and then it is deployed to Development ECS.
[branch_development_pull_request.yml](.github/workflows/branch_development_pull_request.yml)



## Deployment
