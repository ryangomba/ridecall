DEBUG = True
TEMPLATE_DEBUG = DEBUG

ALLOWED_HOSTS = []

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/Users/Ryan/Dropbox/Projects/RideCall/ridecall-server/db/main.sqlite3',

        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '',
    }
}

STATIC_ROOT = ''
STATIC_URL = '/static/'
STATICFILES_DIRS = ()

