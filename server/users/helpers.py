from django.contrib.auth.models import User

def full_name_for_user(user):
    first_name = user.first_name.strip()
    if not first_name:
        return user.username

    full_name = first_name

    last_name = user.last_name.strip()
    if last_name:
        full_name += " %s" % last_name

    return full_name

