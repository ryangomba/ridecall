from django.conf.urls import patterns, url

urlpatterns = patterns('comments.api.views',
    url(r'^$', 'create'),
    url(r'^(\d+)/delete/$', 'delete'),
)

