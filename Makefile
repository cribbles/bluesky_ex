build:
	mix deps.get

console:
	iex -S mix

lint:
	mix format
	mix credo -a --strict
	mix dialyzer

test-unit:
	mix test
