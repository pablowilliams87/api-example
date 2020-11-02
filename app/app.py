import os
import requests
import pandas
# import csv

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy_utils import database_exists, create_database, drop_database

app = Flask(__name__)
#app.config['SQLALCHEMY_DATABASE_URI'] = "postgresql://postgres:mysecretpassword@localhost:5432/environment_airq_measurand"
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DB_URI')
db = SQLAlchemy(app)
from models import EnvironmentAirqMeasurand


@app.cli.command("initdb")
def initdb_command():
  if not database_exists(os.getenv('DB_URI')):
    create_database(os.getenv('DB_URI'))
#  db.create_all()
  url = os.getenv('URL_MEASUREMENTS')
  r = requests.get(url)
  open('/tmp/environment_airq_measurand.csv', 'wb').write(r.content)
  file_name = '/tmp/environment_airq_measurand.csv'
  df = pandas.read_csv(file_name)
  engine=db.create_engine(os.getenv('DB_URI'),{})
  df.to_sql(con=engine, index_label='id_environment_airq_measurand', name=EnvironmentAirqMeasurand.__tablename__, if_exists='replace')


@app.route('/air_quality')
def get_measurements():
  measurements = EnvironmentAirqMeasurand.query.all()
  results = [{
    "TimeInstant": measurement.TimeInstant,
    "id_entity": measurement.id_entity,
    "so2": measurement.so2,
    "no2": measurement.no2,
    "co": measurement.co,
    "o3": measurement.o3,
    "pm10": measurement.pm10,
    "pm2_5": measurement.pm2_5
  } for measurement in measurements]

  return {"measurements": results}
  #TODO: Me gustaria que se imprima solo el json con los datos, sin ese measurements, si pongo 'return results' tira error


if __name__ == '__main__':
  app.run(debug=True, host='0.0.0.0')

