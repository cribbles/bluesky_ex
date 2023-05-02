# BlueskyEx

This is an Elixir client for the [Bluesky](https://blueskyweb.xyz/) /
[AT protocol](https://atproto.com/).

Right now it's in a pretty barebones proof-of-concept state. Contributions
to make it more full-featured are more than welcome :)

## Installation

```sh
make build
```

## Usage

Here's an example CLI session:

```sh
make console
```

```elixir
username = "username"
password = "password"
pds = "https://bsky.social"

creds = %BlueskyEx.Client.Credentials{
  username: username,
  password: password
}
session = BlueskyEx.Client.Session.create(creds, pds)

# Fetch 15 skeets from the timeline
popular = BlueskyEx.Client.RecordManager.get_timeline(session, limit: 15)

# Make a skeet with the text content "skeet"
post = BlueskyEx.Client.RecordManager.create_post(session, text: "skeet")
```

### API reference

See [Hexdocs](https://hexdocs.pm/bluesky_ex).

## Contributing

### Formatting

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

### Type checking

Typespecs are validated through
[dialyzer](https://github.com/jeremyjh/dialyxir).

```sh
mix dialyzer
```

### Helpers

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
