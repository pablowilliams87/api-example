# Prerequisites:
# apt install libpq-dev
# pip3 install flask flask-sqlalchemy psycopg2
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
# from flask_migrate import Migrate

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = "postgresql://postgres:mysecretpassword@localhost:5432/environment_airq_measurand"
db = SQLAlchemy(app)
# migrate = Migrate(app, db)

class EnvironmentAirqMeasurand(db.Model):
    __tablename__ = 'environment_airq_measurand'

    id_environment_airq_measurand = db.Column(db.Integer, primary_key=True)
    timestamp = db.Column(db.String())
    id_entity = db.Column(db.String())
    so2 = db.Column(db.Float())
    no2 = db.Column(db.Float())
    co = db.Column(db.Float())
    o3 = db.Column(db.Float())
    pm10 = db.Column(db.Float())
    pm2_5 = db.Column(db.Float())

    def __init__(self, id_environment_airq_measurand, timestamp, id_entity, so2, no2, co, o3, pm10, pm2_5):
        self.id_environment_airq_measurand = id_environment_airq_measurand
        self.timestamp = timestamp
        self.id_entity = id_entity
        self.so2 = so2
        self.no2 = no2
        self.co = co
        self.o3 = o3
        self.pm10 = pm10
        self.pm2_5 = pm2_5

    def __repr__(self):
        return "<EnvironmentAirqMeasurand {self.id_entity}>"


@app.route('/air_quality')
def get_measurements():
  measurements = EnvironmentAirqMeasurand.query.all()
  results = [{
    "timestamp": measurement.timestamp,
    "id_entity": measurement.id_entity,
    "so2": measurement.so2,
    "no2": measurement.no2,
    "co": measurement.co,
    "o3": measurement.o3,
    "pm10": measurement.pm10,
    "pm2_5": measurement.pm2_5
  } for measurement in measurements]

  return {"measurements": results}

#  return {"hello": "world"}


if __name__ == '__main__':
  app.run(debug=False)
