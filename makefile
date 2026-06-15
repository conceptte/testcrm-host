include .env
export

DC := docker compose
APP := $(DC) exec app

COLOR_GREEN := \033[32m
COLOR_YELLOW := \033[33m
COLOR_RESET := \033[0m

.PHONY: install build up down restart composer require fs schema seed clear reset-db destroy shell

install: build up composer require fs schema seed clear
	@echo "$(COLOR_GREEN)Install complete.$(COLOR_RESET)"
	@echo "Access the application at: http://localhost:$(PORT)"

build:
	$(DC) build

up:
	$(DC) up -d

down:
	$(DC) down

restart: down up

composer:
	$(APP) composer install

require:
	$(APP) composer require conceptte/testcrm

fs:
	@echo "$(COLOR_GREEN)Setting up file system permissions...$(COLOR_RESET)"
	$(APP) mkdir -p temp log
	$(APP) chmod -R 777 temp log

schema:
	@echo "$(COLOR_GREEN)Creating database schema...$(COLOR_RESET)"
	$(APP) php vendor/conceptte/testcrm/database/schema.php

seed:
	@echo "$(COLOR_YELLOW)Seeding database with sample data...$(COLOR_RESET)"
	$(APP) php vendor/conceptte/testcrm/database/seed.php

clear:
	$(APP) rm -rf log temp
	$(APP) mkdir -p temp log
	$(APP) chmod -R 777 temp log

reset-db: schema seed clear
	@echo "$(COLOR_GREEN)Database reset complete.$(COLOR_RESET)"

shell:
	$(APP) sh

db:
	$(DC) exec db sh

destroy:
	@echo "$(COLOR_YELLOW)WARNING: All docker volumes will be deleted.$(COLOR_RESET)"
	@read -p "Continue? [y/N] " ans && [ "$$ans" = "y" ]
	$(DC) down -v --remove-orphans