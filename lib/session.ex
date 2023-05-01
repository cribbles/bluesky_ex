defmodule BlueskyEx.Client.Session do
  @moduledoc """
  A struct representing a Bluesky session.
  """

  alias BlueskyEx.Client.{Credentials, RequestUtils}
  alias HTTPoison

  @type t :: %__MODULE__{
          pds: String.t(),
          access_token: String.t(),
          refresh_token: String.t(),
          did: String.t()
        }

  defstruct [:pds, :access_token, :refresh_token, :did]

  @spec create(Credentials.t(), String.t()) :: BlueskyEx.Client.Session.t()
  def create(%Credentials{username: identifier, password: password}, pds) do
    body = Jason.encode!(%{identifier: identifier, password: password})
    uri = RequestUtils.URI.create_session(pds)
    response = RequestUtils.make_request(uri, body)

    %{"did" => did, "accessJwt" => access_token, "refreshJwt" => refresh_token} =
      Jason.decode!(response.body)

    %__MODULE__{
      pds: pds,
      access_token: access_token,
      refresh_token: refresh_token,
      did: did
    }
  end
end
