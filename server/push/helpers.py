import httplib2 as httplib
import json

h = httplib.Http(".cache")

def truncate_text(text, max_length=160):
    if len(text) > max_length:
        truncated_length = max_length - 3
        return text[:truncated_length] + '...'
    return text

def send_push_message(message):

    headers = {
        'Content-type': 'application/json',
        'X-Parse-Application-Id': '3whfpIsuYrGUZQ5PIEHsm4AauERIBmjHnG2PXKsN',
        'X-Parse-REST-API-Key': 'dwmXnHad81Pghc46O9jZRTL74wWYbD4XTD9LbGAf',
    }

    body = json.dumps({
        'where': {
            'deviceToken': {
                '$in': message.device_ids,
            }
        },
        'data': {
            'alert': truncate_text(message.text),
        },
    })

    resp, content = h.request(
        "https://api.parse.com/1/push",
        "POST",
        headers = headers,
        body = body)

    response = json.loads(content)
    success = response['result'] == True

    if not success:
        print "Push failed: %s" % response

    return success

