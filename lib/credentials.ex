defmodule BlueskyEx.Client.Credentials do
  @moduledoc """
  A struct representing the credentials for a Bluesky user.
  """

  @type t :: %__MODULE__{
          username: String.t(),
          password: String.t()
        }

  defstruct [:username, :password]
end
