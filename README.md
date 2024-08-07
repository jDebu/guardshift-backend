# GuardShift Backend

## Resumen

GuardShift es una aplicación backend que sirve APIs para listar turnos disponibles y confirmados. También calcula la asignación de turnos según la disponibilidad de cada empleado en el rango de días de una semana por servicio. Proporciona tres endpoints que se pueden ver en la sección [CURLs del Proyecto Desplegado](#curls-del-proyecto-desplegado). Estos endpoints son utilizados en el frontend del proyecto, cuyo repositorio se encuentra en [guardshift-frontend](https://github.com/jDebu/guardshift-frontend).

## Requisitos

- **Ruby 3.2.2**
  - Se recomienda usar `rbenv` para gestionar la versión de Ruby. Puedes seguir [esta guía](installation_guide.md#instalación-de-rbenv) para instalar `rbenv`.
- **Rails 7.1**
- **PostgreSQL >= 14**
  - Puedes seguir [esta guía](installation_guide.md#instalación-de-postgresql) para instalar PostgreSQL.

## Configuración Local

1. Clona el repositorio:
   ```bash
   git clone https://github.com/tu_usuario/guardshift-backend.git
   cd guardshift-backend
   ```
1. Instala las dependencias:
   ```bash
   bundle install
   ```
1. Crea la base de datos:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```
1. Levanta el servidor:
   ```bash
   rails s
   ```
## Configuración con Docker

### Requisitos
- Docker
    - Puedes seguir esta guía para instalar Docker.
- Docker Compose
    - Puedes seguir esta guía para instalar Docker Compose.

### Generar credenciales para producción
```bash
rails credentials:edit --environment production
```
### Crear un archivo .env
```bash
# docker-entrypoint
DB_HOST=localhost
DB_USERNAME=rails
DB_NAME_POSTGRES=postgres
# compose
DB_NAME=earthquake_backend_production
DB_HOST_NAME=db
RAILS_ENV=production
DB_PASSWORD=postgres
# COPY the config/credentials/production.key value
RAILS_MASTER_KEY=cc9eed147e62e4d79bff592aa4b8e5xd
# frontend cors
FRONTEND_URL_BASE=http://localhost:5173
```
### Build y Up
```bash
docker compose build
docker compose up -d
docker compose exec backend bin/rails db:create
docker compose exec backend bin/rails db:migrate
docker compose exec backend bin/rails db:seed
```
### Otros Comandos Opcionales
```bash
docker compose exec backend bin/rails c
```
### Actualizar el Scheduler
```bash
docker compose down
docker compose up -d --build
```
### CURLs del Proyecto Desplegado
```bash
curl --location --request GET 'https://jdebu.work/backend/shifts?service_id=1&start_date=2020-03-02&end_date=2020-03-08'

curl --location --request GET 'https://jdebu.work/backend/availabilities?service_id=1&start_date=2020-03-02&end_date=2020-03-08'

curl --location --request POST 'https://jdebu.work/backend/availabilities' \
--header 'Content-Type: application/json' \
--data-raw '{
  "date": "2020-03-23",
  "start_time": "19:00",
  "end_time": "20:00",
  "service_id": 1,
  "employee_id": 1,
  "block_id": null,
  "block_shift_id": null
}'
```

## Recursos adicionales
Para una guía detallada de instalación de herramientas como rbenv, PostgreSQL, Docker y Docker Compose, consulta nuestro [documento de instalación](installation_guide.md).