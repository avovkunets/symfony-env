ARGS = $(filter-out $@,$(MAKECMDGOALS))
MAKEFLAGS += --silent
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

list:
	bash -c "echo; $(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'Makefile'| sort"

#############################
# Docker machine states
#############################

state:
	docker-compose ps

run:
	docker-compose up -d
	$(MAKE) state
	echo "Docker containers have been successfully started"

down:
	docker-compose down
	echo "Docker Down!"

update:
	$(MAKE) down
	docker-compose up -d --build
	$(MAKE) state
	echo "Docker Updated!"

#############################
# General
#############################

env-generate:
	bash ./bin/env_generate.sh

#############################
# Containers actions
#############################

shell-web:
	docker exec -e COLUMNS="220" -w="/var/www/html/symfony" -it php8.3-fpm bash

shell-nginx:
	docker exec -e COLUMNS="220" -it --user root nginx bash

shell-db:
	docker exec -it db bash

shell-localstack:
	docker exec -it localstack bash

nginx-reload:
	docker exec nginx /etc/init.d/nginx reload

db-logs:
	docker-compose exec db tail -f /var/log/mysql/mysql.log

add-fixtures:
	docker-compose exec app-web /var/www/api-server/bin/console doctrine:fixtures:load

rebuild-database:
	docker-compose exec app-web /var/www/api-server/bin/console doctrine:schema:drop --full-database --force
	docker-compose exec app-web /var/www/api-server/bin/console doctrine:migrations:migrate
