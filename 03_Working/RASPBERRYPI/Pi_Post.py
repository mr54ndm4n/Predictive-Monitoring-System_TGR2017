import requests
#import json

#payload = {'key1': 'value1', 'key2': ['value2', 'value3']}
#r = requests.get('http://httpbin.org/get', params=payload)
#print(r.url)

#t = requests.get('https://api.github.com/events', stream=True)
#print(t.raw)
#print(t.raw.read(10))

url = 'http://httpbin.org/post'
files = {'file': open('20-02-2017 17:19:11.jpg', 'rb')}

r = requests.post(url, files=files)

print(r.text)

