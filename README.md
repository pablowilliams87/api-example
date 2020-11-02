## app.py

Test

### Requirements

* Python 3+
* SQAlchemy XX+
* Flask XX+
* etc

### Docker

1- Build

```console
docker build -t test .
```
2- Run

```console
docker run -it --rm -p 5000:5000 test:latest
```


### Local
```console
python3 app/app.py
```

### Test
=======
# api-example

### Docker
#### Build Docker Image
```bash
docker build -t measurement-app:1.1 .
```

#### Run Docker Image
```bash
docker run -it --rm -p 5000:5000 test:latest
```

#### Test
>>>>>>> staging
```bash
curl http://localhost:5000/air_quality
```

### Docker Compose
0- Install
```console
=======
#### Install
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

1- Deploy
```console
docker-compose up
=======
#### Deploy
```bash
docker-compose up --build -d

# [First Run] InitDB
docker exec -ti api-example_api_1 flask initdb
```

#### Delete
```bash
docker-compose down
```
