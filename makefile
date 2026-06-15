include .env
export

COLOR_GREEN := \033[32m
COLOR_YELLOW := \033[33m
COLOR_RESET := \033[0m

.PHONY: install build up composer fs schema seed down

install: build up composer fs schema seed

build:
	docker compose build

up:
	docker compose up -d

composer:
	docker compose exec app composer install && \
	docker compose exec app composer require conceptte/testcrm

fs:
	@echo "$(COLOR_GREEN)Setting up file system permissions...$(COLOR_RESET)" && \
	docker compose exec app mkdir -p temp log && \
	docker compose exec app chmod -R 777 temp log

schema:
	@echo  "$(COLOR_GREEN)Creating database schema...$(COLOR_RESET)" && \
	docker compose exec app php vendor/conceptte/testcrm/database/schema.php

seed:
	@echo "$(COLOR_YELLOW)Seeding database with sample data...$(COLOR_RESET)" && \
	docker compose exec app php vendor/conceptte/testcrm/database/seed.php

down:
	docker compose down

destroy:
	@echo "$(COLOR_YELLOW)WARNING: All docker volumes will be deleted.$(COLOR_RESET)"
	@read -p "Continue? [y/N] " ans && [ "$$ans" = "y" ]
	docker compose down -v --remove-orphans