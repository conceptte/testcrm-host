# testcrm-host

Dockerized host app for [MiniCRM](https://github.com/conceptte/testcrm) package. Runs PHP, Nginx, and MariaDB in Docker containers.

## Requirements

- Docker
- Docker Compose
- `make` (optional, but easier)

## Quick start (with make)

```bash
git clone https://github.com/conceptte/testcrm-host.git
cd testcrm-host
make install
```

That's it. Open `http://localhost:8085` when done.

## Manual setup (without make)

1. Clone the repo:

```bash
git clone https://github.com/conceptte/testcrm-host.git
cd testcrm-host
```

Default values in `.env`:

```
APP_PORT=8085
DB_DATABASE=app
DB_USERNAME=app_user
DB_PASSWORD=secret
DB_ROOT_PASSWORD=root_secret
DB_PORT=3306
```

2. Build and start containers:

```bash
docker compose build
docker compose up -d
```

3. Install PHP dependencies:

```bash
docker compose exec app composer install
docker compose exec app composer require conceptte/testcrm
```

4. Create temp and log directories:

```bash
docker compose exec app mkdir -p temp log
docker compose exec app chmod -R 777 temp log
```

5. Publish assets:

```bash
docker compose exec app sh -c 'mkdir -p www/assets && cp -r vendor/conceptte/testcrm/assets/minicrm www/assets/minicrm'
```

6. Create database schema and seed test data:

```bash
docker compose exec app php vendor/conceptte/testcrm/database/schema.php
docker compose exec app php vendor/conceptte/testcrm/database/seed.php
```
|it could be after seeder `log` and `temp` directories are created with root permissions, so you might need to fix that again:

```bash
docker compose exec app chmod -R 777 temp log
```

Open `http://localhost:8085/minicrm/`.
API endpoints are available at `http://localhost:8085/minicrm/api/v1/`:

- `http://localhost:8085/minicrm/api/v1/customers` - list of customers
    available query parameters:
    - `q` (string) - search customers by name or email
    - `page` (int) - page number for pagination
    - `limit` (int) - number of items per page for pagination

- `http://localhost:8085/minicrm/api/v1/customers/{public_id}` - details of a single customer

## Other commands

```bash
make down          # Stop containers
make restart       # Restart containers
make clear         # Clean temp and log files
make reset-db      # Recreate schema and reseed
make shell         # Open shell inside app container
make destroy       # Remove containers and all volumes (data will be lost)
```
