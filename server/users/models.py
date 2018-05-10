from django.db import models
from django.contrib.auth.models import User

from users.helpers import full_name_for_user

class UserProfile(models.Model):
    user = models.OneToOneField(User, related_name='profile')

    avatar_url = models.CharField(max_length=200, blank=True, null=True)
    bio = models.TextField(blank=True, null=True)

    def __unicode__(self):
        return self.user.__unicode__()

    @property
    def full_name(self):
        return full_name_for_user(self.user)

    def to_dict(self):
        return {
            'pk': self.id,

            'username': self.user.username,
            'full_name': self.full_name,
            'avatar_url': self.avatar_url or '',
            'bio': self.bio or '',
        }

