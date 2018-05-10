import json
import httplib2 as httplib

h = httplib.Http(".cache")

headers = {
    'Content-type': 'application/json',
    'X-Parse-Application-Id': '3whfpIsuYrGUZQ5PIEHsm4AauERIBmjHnG2PXKsN',
    'X-Parse-REST-API-Key': 'dwmXnHad81Pghc46O9jZRTL74wWYbD4XTD9LbGAf',
}

parameters = {
    'where': {
        'deviceToken': {
            '$in': [
                '96bd2903d48e85f84f2da59548b6cd2392e98c6d86dc82dcf1ea114d5aceb83a',
            ],
        }
    },
    'data': {
        'alert': 'Test push',
    },
}
body = json.dumps(parameters)

resp, content = h.request(
    "https://api.parse.com/1/push",
    "POST",
    headers = headers,
    body = body)

print content

