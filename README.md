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