# BlueskyEx

This is an Elixir client for the [Bluesky](https://blueskyweb.xyz/) AT protocol.

Right now it's in a pretty barebones proof-of-concept state, but as of writing
there are no other Elixir clients so it's the only game in town. Contributions
to make it more full-featured are more than welcome :)

## Installation

```sh
make build
```

## Usage

```sh
make console
```

```elixir
username = "username"
password = "password"
pds = "https://bsky.social"

creds = %BlueskyEx.Client.Credentials{username: username, password: password}
session = BlueskyEx.Client.Session.create(creds, pds)

# Fetch two most recent popular skeets
popular = BlueskyEx.Client.RecordManager.get_popular(session, 2)

# Make a skeet with the text content "skeet"
post = BlueskyEx.Client.RecordManager.create_post(session, "skeet")
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

Typespecs are validated through
[dialyzer](https://github.com/jeremyjh/dialyxir).

```sh
mix dialyzer
```

As a shortcut, you can run

```sh
make lint
```

to run all three of the above commands before authoring a commit.

### Guidelines

#### Testing

All public functions "should" be tested exhaustively, but coverage is spotty
right now -- contributions are welcome.

You can run the test suite with

```sh
make test-unit
```

#### Documentation

All public modules and their functions should be documented with the
appropriate typespecs.

This library uses
[ExDoc](https://hexdocs.pm/elixir/1.12/writing-documentation.html)
conventions for documentation. You can run

```sh
make docs
```

to build the docs and open them in your local environment.

## License

MIT
