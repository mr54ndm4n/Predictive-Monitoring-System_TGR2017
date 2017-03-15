from flask import Flask
import requests
import json

WEATHER_ID = '9b0a16392ec219fbe5f10103acd11098'
WEATHER_PLACE = 'Bangkok,th'

app = Flask(__name__)

@app.route('/')
@app.route('/hello')
def HelloWorld():
	weathUrl = 'http://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s'
	param = (WEATHER_PLACE, WEATHER_ID, )
	weath = requests.get(weathUrl% param)
	weathResponse = weath.text
	data = json.loads(weathResponse)
	print json.dumps(data, indent=2)
	return """
			<center><h2>It's %s at %s (Lat:%d, Lon:%d)<br>
			Wind: speed %d and %d degree<br>
			Pressure is %d<br>
			Temp: %d ( %d - %d )<br>
			Humidity = %d</h2></center>
		""" % ( data['weather'][0]['description'], data['name'],
				data['coord']['lat'], data['coord']['lon'],
				data['wind']['speed'], data['wind']['deg'],
				data['main']['pressure'],
				data['main']['temp'], data['main']['temp_min'],
				data['main']['temp_max'], data['main']['humidity'])


if __name__ == '__main__':
	app.debug = True
	app.run(host='0.0.0.0', port=8000)
