import json
import datetime

from django.http import HttpResponse

def json_response(json_dict):
    return HttpResponse(
        json.dumps(json_dict),
        status=200,
        mimetype="application/json"
    )

def json_error(error_code, error_message):
    return HttpResponse(
        json.dumps({'error': error_message}),
        status=error_code,
        mimetype="application/json"
    )

def dt_to_ts(dt):
    return dt.strftime('%s')

def ts_to_dt(ts):
    return datetime.datetime.fromtimestamp(ts)

