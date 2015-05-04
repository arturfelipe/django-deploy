# coding: utf-8
from django.test import TestCase, Client
from django.core.urlresolvers import reverse as r


class HomeViewTest(TestCase):

    def setUp(self):
        client = Client()
        self.resp = client.get(r('landing:home'))

    def test_home_view_exists(self):
        self.assertEqual(200, self.resp.status_code)
