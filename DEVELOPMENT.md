# EVE Indy Watch Development Environment

EVE Indy Watch recommends Visual Studio Code for local development, and includes a full configuration for development in a Docker container with the Visual Studio Code Remote - Containers extension.

## System requirements

**Windows**: Docker Desktop 2.0+ on Windows 10/11 Pro/Enterprise. Windows 10 Home (2004+) requires Docker Desktop 2.3+ and the WSL 2 back-end. (Docker Toolbox is not supported. Windows container images are not supported.)
**macOS**: Docker Desktop 2.0+.
**Linux**: Docker CE/EE 18.06+ and Docker Compose 1.21+. (The Ubuntu snap package is not supported.)
**Remote hosts**: 4 GB RAM is required, but at least 8 GB RAM and a 2-core CPU is recommended.

_Other Docker compliant CLIs may work, but are not officially supported._

## First time setup

1. Follow the steps from the official _[Developing inside a Container using Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/containers#_getting-started)_ guide to prepare Visual Studio Code for development.

1. Open a new window in Visual Studio code and run **Remote-Containers: Clone Repository in Container Volume** from the Command Palette (`F1`, `Cmd+Shift+P`, or `Ctrl+Shift+P`). Enter `https://github.com/bokoboshahni/eve-indy-watch.git` as the repository URL.

1. Copy `.env.example` to `.env` and configure as required (see comments in `.env.example` for details).

1. Open a terminal in Visual Studio Code (`Ctrl+Backtick`) and run `bin/setup` to set up the database for the first time.

1. Run `foreman start -f Procfile.devcontainer` to start the application server, Webpack, and background workers.

1. Navigate to http://localhost:3000 and log in with the character you configured in the `ADMIN_CHARACTER_IDS` setting in `.env`.

1. After you've logged in, navigate to the [ESI authorization settings](http://localhost:3000/settings/authorizations) page and create an ESI authorization for your user.

### Setting up the market

Ensure that `MAIN_ALLIANCE_MARKET_STRUCTURE_ID` in `.env` is set to the ID of the alliance's market structure.

Run the market bootstrapping task:

```
bin/rails bootstrap:markets
```

After a few minutes, you should see green statuses for both Jita and your alliance market on the [market administration page](http://localhost:3000/admin/markets).

## Running tests

```
bin/rspec
```

## Rails console

```
bin/rails c
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

## Troubleshooting

### Tailing development logs

```
tail -f log/development.log
```
