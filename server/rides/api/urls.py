from django.conf.urls import patterns, url

urlpatterns = patterns('rides.api.views',
    url(r'^$', 'rides'),
    url(r'^create/$', 'create'),

    url(r'^(\d+)/$', 'ride'),
    url(r'^(\d+)/edit/$', 'edit'),
    url(r'^(\d+)/commit/$', 'commit'),
    url(r'^(\d+)/cancel/$', 'cancel'),
)

