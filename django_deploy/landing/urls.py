# coding: utf-8
from django.conf.urls import patterns, url


urlpatterns = patterns(
    'django_deploy.landing.views',

    url(r'^$', 'home', name='home'),
)
