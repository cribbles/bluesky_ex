defmodule BlueskyClient.CredentialsTest do
  use ExUnit.Case, async: true
  alias BlueskyClient.Credentials

  describe "BlueskyClient.Credentials struct" do
    test "creates a struct with the expected keys and values" do
      username = "test_user"
      password = "test_password"

      credentials = %Credentials{username: username, password: password}

      assert credentials.username == username
      assert credentials.password == password
    end
  end
end
