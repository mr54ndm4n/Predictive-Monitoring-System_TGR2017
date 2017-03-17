import requests
import sys

filename = 'durianNumber.jpg'
url = 'https://hoykhom-bot.herokuapp.com/dataUpdate'

if __name__ == '__main__':
    amount = int(sys.argv[1])
    pic_file = {'file': open(filename, 'rb')}
    requests.post(url, data={'amount': amount}, files = pic_file)
    sys.stdout.write('Done')