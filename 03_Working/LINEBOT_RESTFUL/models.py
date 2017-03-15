from sqlalchemy import Column, Integer, String, DateTime, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine
import datetime
import psycopg2

Base = declarative_base()

class Weather(Base):
    __tablename__ = 'weather'

    id = Column(Integer, primary_key=True)
    user = Column(String(40))
    picture = Column(String(256))
    datetime = Column(DateTime, default=datetime.datetime.now)
    soil_moisture = Column(Float)
    weather_description = Column(String(40))
    temperature = Column(Float)
    air_pressure = Column(Float)
    air_moisture = Column(Float)

    @property
    def serialize(self):
        return {
            'id': self.id,
            'user': self.user,
            'picture': self.picture,
            'datetime': self.datetime,
            'soil_moisture': self.soil_moisture,
            'weather_description': self.weather_description,
            'air_pressure': self.air_pressure,
            'air_moisture': self.air_moisture,
            'temperature': self.temperature
        }

url = 'postgresql://{}:{}@{}:{}/{}'
url = url.format('hoykhomdb', 'A86qPz9oWnZAao8',
                 '52.230.29.224', 5432, 'tgr2017')
print url

engine = create_engine(url, client_encoding='utf8')
Base.metadata.create_all(engine)
