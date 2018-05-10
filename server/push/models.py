from django.db import models

from devices.models import Device
from push.helpers import send_push_message

class PushMessage(models.Model):
    text = models.TextField()
    recipients = models.TextField()

    def __unicode__(self):
        return self.text

    @property
    def device_ids(self):
        return self.recipients.split(",")

    @classmethod
    def new(cls, text, recipients):
        print "Preparing push to %s (%s)." % (
            ", ".join([r.username for r in recipients]), text)

        if len(recipients) == 0:
            print "Empty recipients list; not creating push message."
            return None

        devices = Device.devices_for_users(recipients)
        device_ids = [d.uuid for d in devices]

        if len(device_ids) == 0:
            print "No devices found; not creating push message"
            return None

        return cls(
            text = text,
            recipients = ",".join(device_ids),
        )

    def send(self):
        return send_push_message(self)

