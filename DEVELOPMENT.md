# EVE Indy Watch Development Environment

EVE Indy Watch recommends Docker Compose for local development, and includes a Docker Compose configuration that should work out of the box.

## First time setup

* `cp .env.example .env`
* Edit `.env` as needed
* `./bin/setup`
* Wait a bit after the setup script that `webpack` has done its job
* Point your browser to http://0.0.0.0:3000
