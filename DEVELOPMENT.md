# EVE Indy Watch Development Environment

EVE Indy Watch recommends Docker Compose for local development, and includes a Docker Compose configuration that should work out of the box.

## First time setup

Ensure all variables in `.env.example` have valid values and then run:

* `docker-compose run --rm worker db:setup sde:download sde:import data:create_jita_market`
