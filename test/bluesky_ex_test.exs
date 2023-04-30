defmodule BlueskyExTest do
  use ExUnit.Case
  doctest BlueskyEx

  test "greets the world" do
    assert BlueskyEx.hello() == :world
  end
end
