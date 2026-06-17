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
reffer to [Makefile](https://github.com/conceptte/testcrm-host/blob/main/makefile) for details of what `make install` does, but basically it builds and starts containers, installs dependencies, sets permissions, publishes assets, creates database schema and seeds test data.

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

4. Create temp and log directories (i didnt setup users and permissions in Dockerfile, so it because 777, which is not ideal for security, but works for development):

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
(again 777 is not ok for production, but works for development)
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
make assets        # Publish assets to www/assets
make clear         # Clean temp and log files
make reset-db      # Recreate schema and reseed
make shell         # Open shell inside app container
make destroy       # Remove containers and all volumes (data will be lost)
```
