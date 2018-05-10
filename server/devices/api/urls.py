from django.conf.urls import patterns, url

urlpatterns = patterns('devices.api.views',
    url(r'^register/$', 'register'),
)


