from django.db import models

class Location(models.Model):
    name = models.CharField(max_length=100)
    latitude = models.FloatField(db_index=True)
    longitude = models.FloatField(db_index=True)
    external_id = models.CharField(max_length=100, blank=True, null=True)

    def __unicode__(self):
        return self.name

    def to_dict(self):
        return {
            'pk': self.id,

            'name': self.name,
            'coordinates': [self.latitude, self.longitude],
        }

