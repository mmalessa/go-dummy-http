# include .env

DEVELOPER_UID = $(shell id -u)
DOCKER_COMPOSE		= $(if $(shell which docker-compose),docker-compose,docker compose)
DC					= $(DOCKER_COMPOSE) --project-directory=".docker" --file=".docker/docker-compose.yaml"

.DEFAULT_GOAL = help

.PHONY: help
help: ## Outputs this help screen
	@grep -hE '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


.PHONY: build
build:
	DEVELOPER_UID=${DEVELOPER_UID} \
	BUILD_TARGET="prod"
		$(DC) build

.PHONY: developer
developer:
	DEVELOPER_UID=${DEVELOPER_UID} \
	BUILD_TARGET="dev" \
		$(DC) build

.PHONY: up
up:
	$(DC) up -d

.PHONY: down
down:
	$(DC) down

.PHONY: console
console:
	$(DC) exec -it app bash

up-prod:
	docker run -p 0.0.0.0:80:80 -d --rm --name go_mock -e APP_INSTANCE=instance1  go_dummy_http-app
down-prod:
	docker stop go_mock


