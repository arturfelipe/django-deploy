PROJECT_NAME=django-deploy

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
	@echo '  deploy                            Executa deploy'
	@echo ''
	@echo '======================================================================='

clean:
	@echo 'Cleaning *.pyc ...'
	@find . -name '*.pyc' -exec rm -rf {} \;

create_env:
	@echo 'Creating virtualenv...'
	@rm -rf .venv
	@virtualenv -p python2.7 --unzip-setuptools .venv
