# coding: utf-8
from datetime import datetime
from fabric.api import env, task, sudo, local, put, run, cd, prefix
from fabric.colors import green
from contextlib import contextmanager
from decouple import config


PROJECT_NAME = 'django-deploy'
PROJECT_PATH = '/var/webapps/' + PROJECT_NAME
VENV_PATH = PROJECT_PATH + '/virtualenv'
APP_PATH = PROJECT_PATH
APP_CURRENT_PATH = PROJECT_PATH + '/{}'.format(PROJECT_NAME)


@task
def prod():
    '''Prod enviroment'''
    env.hosts = ['52.24.9.189']
    env.user = 'ubuntu'
    env.key_filename = '~/.ssh/django_deploy.pem'


def pgreen(str):
    '''Output with green color'''
    print(green(str))


@contextmanager
def venv():
    '''
    Runs commands within the project's virtualenv
    '''
    with cd(VENV_PATH):
        with prefix('source {}/bin/activate'.format(VENV_PATH)):
            yield


@contextmanager
def app():
    '''
    Runs commands within the app's directory.
    '''
    with venv():
        with cd(APP_PATH):
            yield


@contextmanager
def app_current():
    '''
    Runs commands within the app's current directory.
    '''
    with venv():
        with cd(APP_CURRENT_PATH):
            yield


@task
def create_project_structure():
    pgreen('Creating directory structure in {}...'.format(PROJECT_PATH))
    sudo('mkdir -p {}/{{logs,conf,media,static}}'.format(PROJECT_PATH))

    sudo('touch {}/logs/{{gunicorn.log,gunicorn_error.log,nginx-access.log,nginx-error.log}}'.format(PROJECT_PATH))
    sudo('touch {}/conf/env.conf'.format(PROJECT_PATH))

    sudo('virtualenv {} --distribute --unzip-setuptools'.format(VENV_PATH))


@task
def upload():
    pgreen('Upload project...')

    # Generate release
    local('rm -f /tmp/{}.tgz'.format(PROJECT_NAME))
    local('git archive --format=tar --prefix={0}/ HEAD | gzip > /tmp/{0}.tgz'.format(PROJECT_NAME))
    put('/tmp/{}.tgz'.format(PROJECT_NAME), '/tmp/')
    run('tar -C /tmp -zxf /tmp/{}.tgz'.format(PROJECT_NAME))

    with app():
        sudo('rm -rf {}'.format(PROJECT_NAME))
        sudo('mv /tmp/{} ./'.format(PROJECT_NAME))


@task
def install_requirements():
    pgreen('Instaling requirements...')
    with app_current():
        sudo('pip install -r requirements.txt --no-deps')


@task
def command(command):
    with app_current():
        sudo('./manage.py {}'.format(command))


@task
def restart_supervisor():
    pgreen('Restarting supervisor...')
    with venv():
        sudo('supervisorctl restart all')


@task
def deploy():
    upload()
    command('collectstatic --noinput')
    restart_supervisor()
