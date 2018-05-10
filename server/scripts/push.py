import setup_django
setup_django

import sys

from push.models import PushMessage

text = sys.argv[1]
recipients = sys.argv[2]

message = PushMessage()
message.text = text
message.recipients = recipients

print message.send()

