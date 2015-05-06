PROJECT_NAME=django_deploy

help:
	@echo '======================================================================='
	@echo 'Projeto: $(PROJECT_NAME)'
	@echo '-----------------------------------------------------------------------'
	@echo 'Conjunto de tarefas essenciais para o desenvolvimento e '
	@echo 'distribuição do projeto. Para garantir o seu funcionamento é'
	@echo 'necessário estar com o servidor de banco de dados inicializado,'
	@echo 'ter o python2.7 instalado e os pacotes pip e virtualenv.'
	@echo '======================================================================='
	@echo ''
	@echo 'Usage:'
	@echo ''
	@echo '  make <task>'
	@echo ''
	@echo 'Tasks avaiable:'
	@echo '  clean                             Remove arquivos .pyc'
	@echo '  create_env                        Cria virtualenv .venv'
	@echo '  install_requirements              Instala packages python necessário'
	@echo '  create_db                         Cria banco de dados no mysql'
	@echo '  migrate                           Executa migrations do projeto'
	@echo '  install                           Instala projeto e suas dependências'
	@echo '  update                            Atualiza projeto e suas dependências'
	@echo '  run                               Inicia o servidor local na porta 8000'
	@echo '  create_superuser                  Cria um super usuário do admin'
	@echo '  deploy                            Executa deploy para um ambiente'
	@echo '                                    Ex.: make ENV='dev' deploy'
	@echo '  test                              Roda os testes do projeto'
	@echo '  test_app                          Roda os testes de uma app do projeto'
	@echo '                                    Ex.: make APP='landing' test_app'
	@echo ''
	@echo '======================================================================='

clean:
	@echo 'Cleaning *.pyc ...'
	@find . -name '*.pyc' -exec rm -rf {} \;

create_env:
	@echo 'Creating virtualenv...'
	@rm -rf .venv
	@virtualenv -p python2.7 --unzip-setuptools .venv

install_requirements:
	@echo 'Installing python requirements...'
	@source .venv/bin/activate && pip install -Ur requirements_local.txt

create_db:
	@echo 'Creating db...'
	@mysql -u root -e "CREATE DATABASE IF NOT EXISTS $(PROJECT_NAME)";

migrate: create_db
	@echo 'Migratig db...'
	@source .venv/bin/activate && python manage.py migrate

install: clean create_env install_requirements migrate
	@echo 'Installing project...'

update: clean install_requirements migrate

run: update
	@echo 'Running project...'
	@source .venv/bin/activate && python manage.py runserver 0.0.0.0:8000

create_superuser:
	@echo 'Creating superuser...'
	@source .venv/bin/activate && python manage.py createsuperuser

deploy:
	@echo 'Deploy to ${ENV}...'
	@fab ${ENV} deploy

test:
	@echo 'Running tests...'
	@./manage.py test --settings=$(PROJECT_NAME).settings_test

test_app:
	@echo 'Running tests for app: $(PROJECT_NAME).${APP}'
	@./manage.py test --settings=$(PROJECT_NAME).settings_test $(PROJECT_NAME).${APP}
