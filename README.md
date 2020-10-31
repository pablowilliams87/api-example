# api-example

### Build Docker Image
```console
docker build -t measurement-app:1.1 .
```

### Docker Compose
#### Install
```console
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

#### Deploy
```console
docker-compose up --build -d

# InitDB
docker exec -ti api-example_api_1 flask initdb
```

#### Delete
```console
docker-compose down
```
