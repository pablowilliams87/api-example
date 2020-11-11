# Import libraries
import os
import requests
import pandas

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy_utils import database_exists, create_database, drop_database

# Open DB connection
app = Flask(__name__)
#app.config['SQLALCHEMY_DATABASE_URI'] = "postgresql://postgres:mysecretpassword@localhost:5432/environment_airq_measurand"
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DB_URI')
db = SQLAlchemy(app)
from models import EnvironmentAirqMeasurand


# Define flask initdb command
@app.cli.command("initdb")
def initdb_command():
  # Create database if not exist
  if not database_exists(os.getenv('DB_URI')):
    create_database(os.getenv('DB_URI'))

  # Set url with URL_MEASUREMENTS envvar value
  url = os.getenv('URL_MEASUREMENTS')
  # Dowbload csv file
  r = requests.get(url)
  open('/tmp/environment_airq_measurand.csv', 'wb').write(r.content)

  # Read CSV and Load to Database
  file_name = '/tmp/environment_airq_measurand.csv'
  df = pandas.read_csv(file_name)
  engine=db.create_engine(os.getenv('DB_URI'),{})
  df.to_sql(con=engine, index_label='id_environment_airq_measurand', name=EnvironmentAirqMeasurand.__tablename__, if_exists='replace')


@app.route('/air_quality')
def get_measurements():
  # Query all air quality measurements
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

  # Return air quality measurements
  return {"air_quality_measurements": results}

@app.route('/status')
def get_status():
  return ''

if __name__ == '__main__':
  app.run(debug=True, host='0.0.0.0')
