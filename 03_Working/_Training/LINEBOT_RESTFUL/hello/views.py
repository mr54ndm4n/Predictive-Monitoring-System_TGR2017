from django.shortcuts import render
from django.http import HttpResponse

from .models import Greeting, Weather

import requests

# Create your views here.
def index(request):
    return render(request, 'index.html')
    # r = requests.get('http://httpbin.org/status/418')
    # print r.text
    # return HttpResponse('<pre> %s </pre>' % r.text)
    # return HttpResponse('Hello from Python!')
    # return render(request, 'index.html')


def db(request):

    greeting = Greeting()
    greeting.save()

    greetings = Greeting.objects.all()

    return render(request, 'db.html', {'greetings': greetings})

def allWeather(request):
    weather = Weather.objects.all()
    text = [w.serialize() for w in weather]
    return HttpResponse(text)

def latestWeather(request):
    w = Weather.objects.filter(testfield=12).order_by('-id')[0]
    return HttpResponse(str(w.serialize()))

def getWeather(request, weather_id):
    w = Weather.objects.get(id = weather_id)
    return HttpResponse(str(w.serialize()))