import json

from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from ridecall.helpers import json_response, json_error

from django.contrib.auth.models import User
from ridecall.helpers import ts_to_dt
from rides.models import Ride, Commit
from locations.models import Location
import rides.signals as ride_signals

@login_required
def rides(request):
    rides = Ride.objects.order_by('-start_time')
    ride_dicts = [r.to_dict() for r in rides]

    return json_response({
        'rides': ride_dicts,
    })

@login_required
def ride(request, ride_id):
    ride = Ride.objects.get(id=ride_id)
    return json_response({
        'ride': ride.to_dict(),
    })

@require_POST
@csrf_exempt
@login_required
def edit(request, ride_id):
    ride = Ride.objects.get(id=ride_id)

    post_dict = request.POST

    name = post_dict.get('name', '').strip()
    if not name:
        return json_error(400, 'A name is required')

    description = post_dict.get('description', '').strip()

    start_ts = float(post_dict.get('start_time', '0'))
    if not start_ts:
        return json_error(400, 'A valid start_time is required')

    style = post_dict.get('style')
    if not style:
        return json_error(400, 'A valid style is required')

    location_json = post_dict.get('location')
    if not location_json:
        return json_error(400, 'A location is required')

    location_dict = json.loads(location_json)

    location_name = location_dict.get('name', '').strip()
    if not location_name:
        return json_error(400, 'A valid location name is required')

    coordinates = location_dict.get('coordinates')
    if not coordinates:
        return json_error(400, 'A location coordinate is required')

    latitude, longitude = float(coordinates[0]), float(coordinates[1])
    if latitude < -90.0 or latitude > 90.0 or longitude < -180.0 or longitude > 180.0:
        return json_error(400, 'A valid location coordinate is required')

    location = ride.location
    location.name = location_name
    location.latitude = latitude
    location.longitude = longitude
    location.save()

    ride.name = name
    ride.description = description
    ride.start_time = ts_to_dt(start_ts)
    ride.style = style
    ride.save()

    ride.location = location

    ride_signals.ride_updated_signal.send(
        sender = Ride,
        ride = ride,
        caller = request.user,
    )

    return json_response({
        'ride': ride.to_dict(),
    })

@require_POST
@csrf_exempt
@login_required
def create(request):
    post_dict = request.POST

    name = post_dict.get('name', '').strip()
    if not name:
        return json_error(400, 'A name is required')

    description = post_dict.get('description', '').strip()

    start_ts = float(post_dict.get('start_time', '0'))
    if not start_ts:
        return json_error(400, 'A valid start_time is required')

    style = post_dict.get('style')
    if not style:
        return json_error(400, 'A valid style is required')

    location_json = post_dict.get('location')
    if not location_json:
        return json_error(400, 'A location is required')

    location_dict = json.loads(location_json)

    location_name = location_dict.get('name', '').strip()
    if not location_name:
        return json_error(400, 'A valid location name is required')

    coordinates = location_dict.get('coordinates')
    if not coordinates:
        return json_error(400, 'A location coordinate is required')

    latitude, longitude = float(coordinates[0]), float(coordinates[1])
    if latitude < -90.0 or latitude > 90.0 or longitude < -180.0 or longitude > 180.0:
        return json_error(400, 'A valid location coordinate is required')

    location = Location.objects.create(
        name = location_name,
        latitude = latitude,
        longitude = longitude,
    )

    ride = Ride.objects.create(
        caller_id = request.user.id,

        name = name,
        description = description,
        start_time = ts_to_dt(start_ts),
        style = style,
        
        location_id = location.id,
    )

    commit = Commit.objects.create(
        user_id = request.user.id,
        ride_id = ride.id,
        probability = 1.0,
    )

    ride.commit_set.add(commit)

    ride_signals.ride_added_signal.send(
        sender = Ride,
        ride = ride,
        caller = request.user,
    )

    return json_response({
        'ride': ride.to_dict(),
    })

@require_POST
@csrf_exempt
@login_required
def commit(request, ride_id):
    probability = request.POST.get('probability')

    if probability is None:
        return json_error(400, 'Probability value required')

    probability = float(probability)

    if probability < 0.0 or probability > 1.0:
        return json_error(400, 'Invalid probability value')

    commit, created = Commit.objects.get_or_create(
        user_id = request.user.id,
        ride_id = ride_id,
        defaults = {
            'probability': probability,
        },
    )

    if probability > 0.0:
        if not created:
            commit.probability = probability
            commit.save()

        ride_signals.rider_committed_signal.send(
            sender = Ride,
            ride = commit.ride,
            commit = commit,
            committer = request.user,
        )

    else:
        commit.delete()

        ride_signals.rider_uncommitted_signal.send(
            sender = Ride,
            ride = commit.ride,
            commit = commit,
            committer = request.user,
        )

    return json_response({})

@require_POST
@csrf_exempt
@login_required
def cancel(request, ride_id):
    ride = Ride.objects.get(id=ride_id)

    if ride.caller_id != request.user.id:
        return json_error(403, 'You are not authorized to cancel this ride')

    ride_signals.ride_canceled_signal.send(
        sender = Ride,
        ride = ride,
        caller = request.user,
    )

    ride.delete()
    ride.location.delete()

    return json_response({})

