from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.allWeather),
    url(r'^latest/$', views.latestWeather),
    url(r'^(?P<weather_id>[0-9]+)/$', views.getWeather),
]