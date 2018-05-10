from django.db import models
from django.contrib.auth.models import User

from ridecall.helpers import dt_to_ts
from rides.models import Ride

class Comment(models.Model):
    text = models.TextField()
    created = models.DateTimeField(auto_now_add=True, db_index=True)

    author = models.ForeignKey(User)
    ride = models.ForeignKey(Ride)

    def __unicode__(self):
        return self.text

    def to_dict(self):
        return {
            'pk': self.id,

            'author': self.author.profile.to_dict(),
            'text': self.text,
            'created': dt_to_ts(self.created),
        }

