# EVE Indy Watch Development Environment

EVE Indy Watch recommends Docker Compose for local development, and includes a Docker Compose configuration that should work out of the box.

## First time setup

Install `dip`:

```
gem install dip
```

Ensure all variables in `.env.example` have valid values (see comments in `.env.example` for instructions) and then run:

* `dip provision`

### Setting up the market

Log into the application at http://localhost:3000 with the user specified in the `ADMIN_CHARACTER_IDS` setting in order to sync the admin user and main alliance (assuming the admin user is in the same alliance specified by the `MAIN_ALLIANCE_ID` setting).

After you've logged in, navigate to the [ESI authorization settings](http://localhost:3000/settings/authorizations) page and create an ESI authorization for your user.

Ensure that `MAIN_ALLIANCE_MARKET_STRUCTURE_ID` in `.env` is set to the ID of the alliance's market structure.

Run the market bootstrapping task:

```
dip run rails bootstrap:markets
```

After a few minutes, you should see green statuses for both Jita and your alliance market on the [market administration page](http://localhost:3000/admin/markets).

## Rails console

```
dip run rails c
```

### Making ESI requests

Requests to ESI endpoints that don't need authentication can be made simply from the Rails console with:

```
esi.get_character(character_id: User.first.character_id) # Returns JSON response directly

esi.get_character_raw(character_id: User.first.character_id) # Returns full response object
```

See the [API documentation](https://bokoboshahni.github.io/esi-sdk-ruby/ESI/Client.html) for [esi-sdk-ruby](https://github.com/bokoboshahni/esi-sdk-ruby) for a list of all methods.

For authenticated requests:

```
structure = main_alliance.default_location.locatable
headers = esi_authorize!(structure.esi_authorization)
JSON.parse(esi_client.get_universe_structure_raw(structure_id: structure.id, headers: headers).body)
```

## Bash shell

```
dip run shell
```

It's useful to keep this container running in order to run tests, if only using Docker for development.

## Troubleshooting

### Tailing development logs

```
dip run shell
tail -f log/development.log
```
