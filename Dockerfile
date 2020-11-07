FROM python:3.8-slim

WORKDIR /

COPY app/ .

RUN apt-get update && \ 
  apt-get install -y libpq-dev gcc && \
  rm -rf /var/lib/apt/lists/* && \
  pip install --no-cache-dir -r requirements.txt

ENV DB_URI=postgresql://postgres:mysecretpassword@db-host:5432/environment_airq_measurand \
  URL_MEASUREMENTS=https://gist.githubusercontent.com/jvillarf/040c91397d779d4da02fff54708ca935/raw/f1dbbcbfbc4e3daace7d907a3cc5b716ef808014/environment_airq_measurand.csv \
  FLASK_APP=app.py

EXPOSE 5000

#ENTRYPOINT [ "flask" ]

CMD [ "flask","run","--host=0.0.0.0" ]
