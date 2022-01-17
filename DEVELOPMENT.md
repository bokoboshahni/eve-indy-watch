# EVE Indy Watch Development Environment

EVE Indy Watch recommends Docker Compose for local development, and includes a Docker Compose configuration that should work out of the box.

## First time setup

Ensure all variables in `.env.example` have valid values and then run:

* `docker-compose run --rm worker db:setup sde:download sde:import data:create_jita_market`

### Setting up the main alliance

Log into the application at http://localhost:3000 with the user specified in the `ADMIN_USER_IDS` setting in order to sync the admin user and main alliance (assuming the admin user is in the same alliance specified by the `MAIN_ALLIANCE_ID` setting).

After you've logged in, navigate to the [ESI authorization settings](http://localhost:3000/settings/authorizations) page and create an ESI authorization for your user.

Open a Rails console:

```
docker-compose run --rm web bin/rails c
```

Fetch your user's authorization and alliance for later use:

```
auth = ESIAuthorization.find_by!(character_id: app_config.admin_character_ids.first)
```

Sync the structure used for your alliance market:

```
structure_id = <YOUR ALLIANCE MARKET STRUCTURE ID>
structure = Structure::SyncFromESI.call(structure_id, authorization: auth)
```

Use your ESI authorization for the structure:

```
structure.update(esi_authorization: auth)
```

Create a market for the structure:

```
region = structure.region
market = Market.create!(name: structure.solar_system_name, source_location: structure.region.location, type_history_region: structure.region, private: true, owner: main_alliance)
market.structures << structure
market.update(active: true)
```

Sync the market for the first time:

```
structure.snapshot_orders_async
```

Monitor the jobs on the (Sidekiq monitoring page)[http://localhost:3000/admin/sidekiq/busy] and verify that the market has been snapshotted:

```
market.latest_snapshot_time # Should return a DateTime object
```

Update the alliance to specify the main market and appraisal market (assuming that you've created the Jita market with `docker-compose run --rm bin/rails c data:create_jita_market`):

```
main_alliance.update(main_market: market, appraisal_market: Market.find_by!(name: 'Jita'))
```

Add the alliance market structure as the default location for procurement orders:

```
main_alliance.alliance_locations.create!(location: structure.location, default: true)
```

## Rails console

Use the `web` or `worker` service to open a Rails console:

```
docker-compose run --rm web bin/rails c
```

## Bash shell

Use the `web` or `worker` service to open a Bash shell:

```
docker-compose run --rm web bash
```

It's useful to keep this container running in order to run tests, if only using Docker for development.
