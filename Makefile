build:
	mix deps.get

lint:
	mix format
	mix credo -a --strict
	mix dialyzer

test-unit:
	mix test
