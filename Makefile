.PHONY: up down restart pull recreate logs status ps health clean update setup deploy sync ssh help

include .env

COMPOSE = docker compose
SERVER_PATH ?= ~/homelab
SSH_TARGET = $(USER)@$(PUBLIC_DOMAIN)
remote = ssh $(SSH_TARGET) "cd $(SERVER_PATH) && $(1)"

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Start all services (or pass s=<service>)
	$(COMPOSE) up -d $(s)

down: ## Stop all services (or pass s=<service>)
	$(COMPOSE) down $(s)

restart: ## Restart all services (or pass s=<service>)
	$(COMPOSE) restart $(s)

pull: ## Pull latest images (or pass s=<service>)
	$(COMPOSE) pull $(s)

recreate: ## Force recreate a service (pass s=<service>)
	$(COMPOSE) up -d --force-recreate $(s)

logs: ## Tail logs (or pass s=<service>)
	$(COMPOSE) logs -f --tail=100 $(s)

ps: ## List running containers
	$(COMPOSE) ps

status: ## Show container resource usage
	docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

health: ## Show health status for a container (pass s=<service>)
	@docker inspect --format='{{json .State.Health}}' $(s) | jq

clean: ## Remove stopped containers, dangling images, and unused volumes
	docker system prune -f
	docker volume prune -f

add-user: ## Add an Authelia user (pass user= email= pass= groups=admin)
	./scripts/authelia-add-user.sh "$(user)" "$(email)" "$(pass)" "$(or $(groups),admin)"

setup: ## Run initial server setup
	chmod +x scripts/setup.sh
	./scripts/setup.sh

shell: ## Open a shell in a running container (pass s=<service>)
	$(COMPOSE) exec $(s) sh

update: ## Pull latest changes (reset local modifications)
	git checkout .
	git clean -fd
	git pull

validate: ## Validate compose file
	$(COMPOSE) config --quiet && echo "compose.yaml is valid"

ssh: ## Open an SSH session to the server
	ssh -t $(SSH_TARGET) "cd $(SERVER_PATH) && exec \$$SHELL -l"

sync: ## Sync changes to server for testing
	git ls-files --cached --modified --others --exclude-standard | sort -u | rsync -avz --files-from=- ./ $(SSH_TARGET):$(SERVER_PATH)/

deploy: sync ## Deploy to server via sync and restart
	$(call remote,make up)
