from django.dispatch import receiver

from comments.signals import comment_added_signal
import rides.signals as ride_signals

from django.contrib.auth.models import User
from users.helpers import full_name_for_user
from push.models import PushMessage

""" Rides """

@receiver(ride_signals.ride_added_signal)
def on_ride_added(sender, **kwargs):
    print "SIGNAL: Ride added"

    ride = kwargs["ride"]
    caller = kwargs["caller"]

    recipients = list(User.objects.all())
    recipients.remove(caller)

    text = '%s called a ride for %s: "%s"' % (
        full_name_for_user(caller),
        ride.start_time,
        ride.name,
    )

    message = PushMessage.new(text, recipients)
    if message:
        message.send()

@receiver(ride_signals.ride_updated_signal)
def on_ride_updated(sender, **kwargs):
    print "SIGNAL: Ride updated"

    ride = kwargs["ride"]
    caller = kwargs["caller"]

    recipients = ride.riders()
    recipients.remove(caller)

    text = "%s updated %s" % (
        full_name_for_user(caller),
        ride.name,
    )

    message = PushMessage.new(text, recipients)
    if message:
        message.send()

@receiver(ride_signals.ride_canceled_signal)
def on_ride_canceled(sender, **kwargs):
    print "SIGNAL: Ride canceled"

    ride = kwargs["ride"]
    caller = kwargs["caller"]

    recipients = ride.riders()
    recipients.remove(caller)

    text = "%s canceled %s" % (
        full_name_for_user(caller),
        ride.name,
    )

    message = PushMessage.new(text, recipients)
    if message:
        message.send()

""" Commits """

@receiver(ride_signals.rider_committed_signal)
def on_rider_committed(sender, **kwargs):
    print "SIGNAL: Rider committed"

    ride = kwargs["ride"]
    commit = kwargs["commit"]
    committer = kwargs["committer"]

    recipients = ride.riders()
    recipients.remove(committer)

    text = "%s committed to %s (+%.01f)" % (
        full_name_for_user(committer),
        ride.name,
        commit.probability,
    )

    message = PushMessage.new(text, recipients)
    if message:
        message.send()

@receiver(ride_signals.rider_uncommitted_signal)
def on_rider_uncommitted(sender, **kwargs):
    print "SIGNAL: Rider uncommitted"

    ride = kwargs["ride"]
    committer = kwargs["committer"]

    recipients = ride.riders()
    recipients.remove(committer)

    text = "%s uncommitted to" % (
        full_name_for_user(committer),
        ride.name,
    )

    message = PushMessage.new(text, recipients)
    if message:
        message.send()

""" Comments """

@receiver(comment_added_signal)
def on_comment_added(sender, **kwargs):
    print "SIGNAL: Comment added"

    ride =  kwargs["ride"]
    comment = kwargs["comment"]
    commenter = kwargs["commenter"]

    recipients = ride.riders()
    recipients.remove(commenter)

    text = '%s commented on %s: "%s"' % (
        full_name_for_user(commenter),
        ride.name,
        comment.text,
    )

    message = PushMessage.new(text, recipients)
    if message:
        message.send()

