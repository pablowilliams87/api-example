FROM python:3.8-slim

WORKDIR /

COPY app/ .

RUN apt-get update && apt-get install -y libpq-dev gcc && pip install -r requirements.txt

ENV DB_URI=postgresql://postgres:mysecretpassword@db-host:5432/environment_airq_measurand

EXPOSE 5000

CMD [ "python", "./app.py" ]
