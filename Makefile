SHELL=/bin/bash

.DEFAULT_GOAL := help

.PHONY: help
help: ## Shows this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: clean install

.PHONY: clean
clean: ## Removes project virtual env
	rm -rf .venv build dist **/*.egg-info .pytest_cache node_modules .coverage

.PHONY: install
install: ## Install the project dependencies and pre-commit using Poetry.
	poetry install
	poetry run pre-commit install --hook-type pre-commit --hook-type commit-msg --hook-type pre-push


.PHONY: test
test: ## Run tests
	poetry run python -m pytest --cov=data_api_project --cov-report html

.PHONY: update
update: ## Run update poetry
	poetry update

.PHONY: curl_druid
curl_druid: ##curl druid
	curl https://dlcdn.apache.org/druid/24.0.1/apache-druid-24.0.1-bin.tar.gz > ./apache_druid_example/apache-druid-24.0.1-bin.tar.gz

.PHONY: unzip_druid
unzip_druid: ##unzip druid
	tar -xzf ./apache-druid-24.0.1-bin.tar.gz -C ./apache_druid_example/

.PHONY: up_druid
up_druid: ##up-druid
	./apache_druid_example/apache-druid-24.0.1/bin/start-micro-quickstart

.PHONY: start_druid
start_druid: curl_druid unzip_druid up_druid

.PHONY: start_kafka
start_kafka:  ##start_kafka
	docker-compose -f ./docker-compose-files/kafka-docker-composer.yaml up -d

.PHONY: down_kafka
down_kafka:  ##down_kafka
	docker-compose -f ./docker-compose-files/kafka-docker-composer.yaml down
