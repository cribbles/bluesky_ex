# BlueskyEx

This is an Elixir client for the [Bluesky](https://blueskyweb.xyz/) AT protocol.

Right now it's in a pretty barebones proof-of-concept state, but as of writing
there are no other Elixir clients so it's the only game in town. Contributions
to make it more full-featured are more than welcome :)

## Usage

```elixir
username = "username"
password = "password"
pds = "https://bsky.social"
creds = %BlueskyClient.Credentials{username: username, password: password}
session = BlueskyClient.Session.create(creds, pds)
popular = BlueskyClient.RecordManager.get_popular(session, 2)
post = BlueskyClient.RecordManager.create_post(session, "skeet")
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bluesky_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bluesky_ex, "~> 0.1.0"}
  ]
end
```

## Contributing

This project uses [credo](http://credo-ci.org/) and
[formatter](https://hexdocs.pm/mix/master/Mix.Tasks.Format.html) for style
consistency. Please run

```sh
mix format
```

and

```sh
mix credo -a --strict
```

before committing changes.

### Guidelines

#### Testing

All public functions "should" be tested exhaustively, but coverage is spotty
right now -- contributions are welcome.

#### Documentation

All public modules and their functions should be documented with the
appropriate typespecs.

This library uses
[ExDoc](https://hexdocs.pm/elixir/1.12/writing-documentation.html)
conventions for documentation. You can run

```sh
mix docs
```

to build the docs and open them in your local environment.

Typespecs are validated through
[dialyzer](https://github.com/jeremyjh/dialyxir).

```sh
mix dialyzer
```

## License

MIT
