# django-deploy

Django Deploy is a project created to demonstrate some basic concepts of how to
deploy and serve a Django project in a production enviroment.

You can fork the project and customize it for your needs. Fell free to send any
comments, questions, suggestions or pull requests.

# Install

To install the project and see it running locally, follow the steps below:

* Clone the project to a folder of your needs

```
git clone git@github.com:arturfelipe/django-deploy.git
```

* You should have python 2.7.x installed, pip and virtualenv your machine. If
you don't have virtualenv installed run:

```
pip install virtualenv
```

* There's a Makefile in the project that helps you to setup:

```
make install
make run
```

# Config server

In this example we are using an ubuntu instance hosted at AWS to serve our app,
follow the steps below to install same basics:

```
chmod 400 ~/.ssh/django_deploy.pem
ssh -i ~/.ssh/django_deploy.pem ubuntu@52.24.9.189
```

#### Update apt-get
```
sudo apt-get update && sudo apt-get upgrade
```

#### Install git
```
sudo apt-get install git
```

#### Install nginx
```
sudo apt-get install nginx
```

#### Install python essentials
```
sudo apt-get install python-pip python-dev build-essential
sudo apt-get install libcurl4-openssl-dev
```

#### Install virtualenv
```
sudo pip install virtualenv
```

#### Setup enviroment
```
fab prod create_project_structure
fab prod create_virtualenv
fab prod upload
fab prod install_requirements
```

#### Config Nginx
Change the `nginx.conf` file at `/etc/nginx/nginx.conf` to the contents of
`conf/nginx.conf`.

Restart nginx:
```
sudo service nginx restart
```

#### Config Supervisor
Place the `conf/supervisord.conf` to the `/etc/` server folder.

And start supervisoring (your viirtualenv must be activated):

```
supervisord -c /etc/supervisord.conf
```
