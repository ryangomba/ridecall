from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from ridecall.helpers import json_response, json_error

from devices.models import Device

@require_POST
@require_POST
@login_required
def register(request):
    post_dict = request.POST

    device_id = post_dict.get('uuid')
    if not device_id:
        return json_error(400, 'uuid required')

    device, created = Device.objects.get_or_create(
        user_id = request.user.id,
        uuid = device_id,
    )

    if not created:
        device.save()

    return json_response({})

