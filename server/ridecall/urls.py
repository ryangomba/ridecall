from django.conf.urls import patterns, include, url

from django.contrib import admin
from django.contrib.auth.models import Group
admin.autodiscover()
admin.site.unregister(Group)

urlpatterns = patterns('',
    url(r'^$', 'ridecall.views.index'),

    url(r'^api/auth/', include('auth.api.urls')),
    url(r'^api/rides/', include('rides.api.urls')),
    url(r'^api/comments/', include('comments.api.urls')),
    url(r'^api/devices/', include('devices.api.urls')),

    url(r'^admin/', include(admin.site.urls)),
)
