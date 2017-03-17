import requests, json
import sys

if __name__ == '__main__':
    nameFile = str(sys.argv[1])
    data = {'file':open(nameFile, "rb"), \
        "appId":("", "35b0473e-5da3-40ca-b90b-f05461e90fb1")}
    url = "http://demo.nanonets.ai/ImageCategorization/Label/"
    r = requests.post(url, files=data)

    # print r.content
    data = json.loads(r.content)
    label1 = data['result'][0]['prediction'][0]['label'];
    label2 = data['result'][0]['prediction'][1]['label'];
    value1 = data['result'][0]['prediction'][0]['probability'];
    value2 = data['result'][0]['prediction'][1]['probability'];
    # sys.stdout.write( data['result'][0]['prediction'][0]['label'] +'\n'+ \
    # 	str(data['result'][0]['prediction'][0]['probability']) +'\n'+ \
    # 	data['result'][0]['prediction'][1]['label']+'\n'+ \
    # 	str(data['result'][0]['prediction'][1]['probability'] ) )
    strPrint = "%s = %.5f \n%s = %.5f\n" % (label1 , value1 , label2 , value2) ;
    sys.stdout.write(strPrint);
# import requests, json
# data = {'file':open("durian01.jpg", "rb"), \
#     "appId":("", "35b0473e-5da3-40ca-b90b-f05461e90fb1")}
# url = "http://demo.nanonets.ai/ImageCategorization/Label/"
# r = requests.post(url, files=data)
# print( r.content)
# data = json.loads(r.content)
# print(data.result[0])