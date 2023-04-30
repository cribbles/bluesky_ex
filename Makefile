build:
	mix deps.get

console:
	iex -S mix

docs:
	mix docs

lint:
	mix format
	mix credo -a --strict
	mix dialyzer

publish:
	mix hex.publish

test-unit:
	mix test
