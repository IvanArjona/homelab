.PHONY: up down restart pull logs status ps clean update setup backup help

COMPOSE = docker compose

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Start all services (or pass s=<service>)
	$(COMPOSE) up -d $(s)

down: ## Stop all services (or pass s=<service>)
	$(COMPOSE) down $(s)

restart: ## Restart all services (or pass s=<service>)
	$(COMPOSE) restart $(s)

logs: ## Tail logs (or pass s=<service>)
	$(COMPOSE) logs -f --tail=100 $(s)

ps: ## List running containers
	$(COMPOSE) ps

status: ## Show container resource usage
	docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

clean: ## Remove stopped containers, dangling images, and unused volumes
	docker system prune -f
	docker volume prune -f

setup: ## Run initial server setup
	chmod +x scripts/setup.sh
	./scripts/setup.sh

shell: ## Open a shell in a running container (pass s=<service>)
	$(COMPOSE) exec $(s) sh

validate: ## Validate compose file
	$(COMPOSE) config --quiet && echo "compose.yaml is valid"
