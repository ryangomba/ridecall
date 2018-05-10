from django.conf.urls import patterns, url

urlpatterns = patterns('auth.api.views',
    url(r'^register/$', 'register'),
    url(r'^login/$', 'login'),
    url(r'^logout/$', 'logout'),
)

