from app import db

class EnvironmentAirqMeasurand(db.Model):
  __tablename__ = 'environment_airq_measurand'

  id_environment_airq_measurand = db.Column(db.Integer, primary_key=True)
  TimeInstant = db.Column(db.String())
  id_entity = db.Column(db.String())
  so2 = db.Column(db.Float())
  no2 = db.Column(db.Float())
  co = db.Column(db.Float())
  o3 = db.Column(db.Float())
  pm10 = db.Column(db.Float())
  pm2_5 = db.Column(db.Float())

  def __init__(self, id_environment_airq_measurand, timestamp, id_entity, so2, no2, co, o3, pm10, pm2_5):
    self.id_environment_airq_measurand = id_environment_airq_measurand
    self.TimeInstant = TimeInstant
    self.id_entity = id_entity
    self.so2 = so2
    self.no2 = no2
    self.co = co
    self.o3 = o3
    self.pm10 = pm10
    self.pm2_5 = pm2_5

  def __repr__(self):
    return "<EnvironmentAirqMeasurand {self.id_entity}>"
