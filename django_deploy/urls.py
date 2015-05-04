# coding: utf-8
from django.conf.urls import include, url


urlpatterns = (
    url(r'', include('django_deploy.landing.urls', namespace='landing')),
)
