from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from ridecall.helpers import json_response, json_error

from rides.models import Ride
from comments.models import Comment
from comments.signals import comment_added_signal

@require_POST
@csrf_exempt
@login_required
def create(request):
    post_dict = request.POST
    ride_id = post_dict.get('ride_id')
    text = post_dict.get('text', '').strip()

    comment = None

    try:
        ride = Ride.objects.get(id=ride_id)
    except Ride.DoesNotExist:
        return json_error(404, 'Ride not found')

    comment = Comment(
        author_id = request.user.id,
        ride_id = ride_id,
        text = text,
    )
    comment.save()

    comment_added_signal.send(
        sender = Comment,
        ride = ride,
        comment = comment,
        commenter = request.user,
    )

    return json_response({
        'comment': comment.to_dict(),
    })

@require_POST
@csrf_exempt
@login_required
def delete(request, comment_id):

    try:
        comment = Comment.objects.get(id=comment_id)
    except Comment.DoesNotExist:
        return json_error(404, 'Comment not found')

    if comment.author_id != request.user.id:
        return json_error(403, 'You are not authorized to delete this comment')

    comment.delete()

    return json_response({})

