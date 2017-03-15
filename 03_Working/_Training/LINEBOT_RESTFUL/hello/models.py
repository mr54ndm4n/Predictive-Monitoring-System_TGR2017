from django.db import models

# Create your models here.
class Greeting(models.Model):
    when = models.DateTimeField('date created', auto_now_add=True)


class Weather(models.Model):
    user = models.CharField(max_length=40)
    picture = models.CharField(max_length=60)
    datetime = models.DateTimeField(auto_now_add=True)
    soil_moisture = models.FloatField()
    weather_description = models.CharField(max_length=30)
    air_pressure = models.FloatField()
    air_moisture = models.FloatField()
    temperature = models.FloatField()

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