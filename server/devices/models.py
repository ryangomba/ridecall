from django.db import models
from django.contrib.auth.models import User

class Device(models.Model):
    uuid = models.CharField(max_length=100)
    last_access = models.DateTimeField(auto_now=True, db_index=True)

    user = models.ForeignKey(User)

    def __unicode__(self):
        return '%s (%s)' % (self.user, self.uuid)

    @classmethod
    def devices_for_users(cls, users):
        return []

