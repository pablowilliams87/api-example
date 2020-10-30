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
```bash
curl http://localhost:5000/air_quality
```

### Docker Compose
0- Install
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

1- Deploy
docker-compose up
