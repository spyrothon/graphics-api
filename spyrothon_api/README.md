# Graphics API

API powering the live graphics for Spyrothon. Managing run information, scheduling, and other dynamic data, as well as providing real-time communication between interfaces (graphics, dashboards, informational services, etc.).

## Usage

This project runs on:

- erlang 24.0.4
- elixir 1.12.2-otp-24
- postgres 14.5 (any version higher than 12)

These dependencies are specified in the `.tool-versions` file. You can easily install these with `asdf` and the respective plugins.

This is a standard Elixir web project, but it is not built with Phoenix. Because of that, the running steps are a bit more involved.

First, ensure you have a local config, and update the values for your local install:

```bash
cp config/dev.example.exs config/dev.exs
# Edit values for DB, Twitch access, etc.
```

Then, to get all of the infrastructure set up, including package dependencies and the database:

```bash
mix deps.get
mix graphics.initialize
```

Then, to run the server:

```bash
mix run --no-halt
```

## Twitch Setup

Once you have at least a `client_id` specified in the `dev.json`  , you can use the access_token tool to get a user access token for a channel with `cd tools/access_token && yarn get` (assumes `dev` environment currently).
