# Graphics API

API powering the live graphics for Spyrothon. Managing run information, scheduling, and other dynamic data, as well as providing real-time communication between interfaces (graphics, dashboards, informational services, etc.).

## Usage

This project runs on:

- Elixir 1.10.3
- Erlang 22.2.1/OTP 22

These dependencies are specified in the `.tool-versions` file.

This is a standard Elixir web project, but it is not built with Phoenix. Because of that, the running steps are a bit more involved.

First, to get all of the infrastructure set up, including package dependencies and the database:

```bash
mix deps.get, deps.compile, compile
mix ecto.create
mix ecto.migrate
```

Then, to run the server:

```bash
mix run --no-halt
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `graphics_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:graphics_api, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/graphics_api](https://hexdocs.pm/graphics_api).
