include .env
export

DC := docker compose
APP := $(DC) exec app

 OWN := \033[35m[MiniCRM] 

COLOR_RESET := \033[0m
COLOR_GREEN := $(OWN)\033[32m
COLOR_YELLOW := $(OWN)\033[33m
COLOR_VIOLET := $(OWN)\033[35m
COLOR_BLUE := $(OWN)\033[34m
COLOR_RED := $(OWN)\033[31m

.PHONY: install build up down restart composer require fs schema seed clear reset-db destroy shell

install: build up composer require fs assets schema seed clear
	@echo "$(COLOR_GREEN)Install complete.$(COLOR_RESET)"
	@echo "$(COLOR_VIOLET)Access the application at: http://localhost:$(APP_PORT)/minicrm/$(COLOR_RESET)"

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
	@echo "$(COLOR_BLUE)Creating database schema...$(COLOR_RESET)"
	$(APP) php vendor/conceptte/testcrm/database/schema.php

seed:
	@echo "$(COLOR_BLUE)Seeding database with sample data...$(COLOR_RESET)"
	$(APP) php vendor/conceptte/testcrm/database/seed.php

clear:
	@echo "$(COLOR_YELLOW)Clearing temporary files...$(COLOR_RESET)"
	$(APP) rm -rf log temp
	$(APP) mkdir -p temp log
	$(APP) chmod -R 777 temp log

reset-db: schema seed clear
	@echo "$(COLOR_YELLOW)Database reset complete.$(COLOR_RESET)"

shell:
	$(APP) sh

db:
	$(DC) exec db sh

assets:
	@echo "$(COLOR_GREEN)Copying assets...$(COLOR_RESET)"
	$(APP) sh -c 'mkdir -p www/assets && cp -r vendor/conceptte/testcrm/assets/minicrm www/assets/minicrm'

destroy:
	@echo "$(COLOR_RED)WARNING: All docker volumes will be deleted.$(COLOR_RESET)"
	@read -p "Continue? [y/N] " ans && [ "$$ans" = "y" ]
	$(DC) down -v --remove-orphans