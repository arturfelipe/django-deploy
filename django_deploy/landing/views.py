# coding: utf-8
from django.shortcuts import render


def home(request):
    '''Index page'''
    context = {}
    return render(request, 'landing/home.html', context)
