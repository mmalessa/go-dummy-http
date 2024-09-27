DC = docker compose
DEVELOPER_UID = $(shell id -u)

.DEFAULT_GOAL = help

.PHONY: help
help: ## Outputs this help screen
	@grep -hE '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


.PHONY: build
build:
	BUILD_TARGET="prod" $(DC) build

.PHONY: developer
developer:
	DEVELOPER_UID=${DEVELOPER_UID} BUILD_TARGET="dev" $(DC) build

.PHONY: binary
binary:
	$(DC) exec app sh -c "go build -o bin/"

.PHONY: up
up:
	$(DC) up -d

.PHONY: down
down:
	$(DC) down

.PHONY: shell
shell:
	$(DC) exec -it app bash

up-prod:
	docker run -p 0.0.0.0:80:80 -d --rm --name go_mock -e APP_INSTANCE=instance1  go_dummy_http-app
down-prod:
	docker stop go_mock


