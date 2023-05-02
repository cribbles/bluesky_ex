build:
	mix deps.get

compile:
	mix compile --warnings-as-errors

console:
	iex -S mix

docs:
	mix docs
	open doc/index.html

lint:
	mix format
	mix credo -a --strict
	mix dialyzer

publish:
	mix hex.publish

test-unit:
	mix test
