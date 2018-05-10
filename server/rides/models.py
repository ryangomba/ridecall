from django.db import models
from django.contrib.auth.models import User

from ridecall.helpers import dt_to_ts
from locations.models import Location
from rides.constants import RIDE_STYLE_CHOICES

class Ride(models.Model):
    name = models.CharField(max_length=140)
    description = models.TextField(blank=True, null=True)
    start_time = models.DateTimeField(db_index=True)
    style = models.CharField(max_length=3, choices=RIDE_STYLE_CHOICES, db_index=True)
    status = models.IntegerField(default=0, db_index=True)

    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    location = models.ForeignKey(Location)
    caller = models.ForeignKey(User, related_name='caller+')
    attendees = models.ManyToManyField(User, related_name='attendees+', through='Commit')
    
    def __unicode__(self):
        return self.name

    def riders(self):
        riders = set([self.caller])
        attendees = list(self.attendees.all())
        riders.update(attendees)
        return riders

    def to_dict(self):
        commits = self.commit_set.order_by('created')
        comments = self.comment_set.order_by('created')

        return {
            'pk': self.id,

            'name': self.name,
            'description': self.description or '',
            'style': self.style,
            'start_time': dt_to_ts(self.start_time),
            'status': self.status,

            'created': dt_to_ts(self.created),
            'updated': dt_to_ts(self.updated),

            'location': self.location.to_dict(),
            'caller': self.caller.profile.to_dict(),
            'attendees': [c.to_dict() for c in commits],

            'comments': [c.to_dict() for c in comments],
        }

class Commit(models.Model):
    probability = models.FloatField()
    created = models.DateTimeField(auto_now_add=True, db_index=True)

    user = models.ForeignKey(User)
    ride = models.ForeignKey(Ride)

    def __unicode__(self):
        return "%s -> %s (+%.01f)" % (
            self.user.profile, self.ride, self.probability)


    def to_dict(self):
        return {
            'user': self.user.profile.to_dict(),
            'probability': self.probability,
            'created': dt_to_ts(self.created),
        }

