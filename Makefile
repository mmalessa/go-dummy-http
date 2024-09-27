DC = docker compose
DEVELOPER_UID = $(shell id -u)

.DEFAULT_GOAL = help

.PHONY: help
help: ## Outputs this help screen
	@grep -hE '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.PHONY: build-dev
build-dev:
	DEVELOPER_UID=${DEVELOPER_UID} BUILD_TARGET="dev" $(DC) build

.PHONY: up
up:
	$(DC) up -d

.PHONY: down
down:
	$(DC) down

.PHONY: shell
shell:
	$(DC) exec -it app bash

.PHONY: binary
binary: up ## Build binary file into 'bin/'
	$(DC) exec app sh -c "GOOS=linux GOARCH=amd64 go build -o bin/dummy-http"
	$(DC) exec app sh -c "GOOS=windows GOARCH=amd64 go build -o bin/dummy-http.exe"

.PHONY: build-prod
build-prod: ## build prod image
	BUILD_TARGET="prod" $(DC) build
up-prod: ## prod image up
	docker run -p 0.0.0.0:80:80 -d --rm --name dummy-http -e APP_INSTANCE=instance1  go-dummy-http-prod
down-prod: ## prod image stop
	docker stop dummy-http


