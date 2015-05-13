#!/bin/bash

APP_DIR=/var/webapps/django-deploy
NAME="django_deploy"
VENV_DIR=$APP_DIR/virtualenv/
DJANGO_DIR=$APP_DIR/django-deploy
NUM_WORKERS=1

DJANGO_SETTINGS_MODULE=django_deploy.settings
DJANGO_WSGI_MODULE=django_deploy.wsgi

echo "Starting gunicorn for app '$NAME' "

# Activate the virtual environment
cd $DJANGO_DIR
source $VENV_DIR/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGO_DIR:$PYTHONPATH

# Start django gunicorn
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  -b 127.0.0.1:8000
