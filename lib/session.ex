defmodule BlueskyClient.Session do
  @moduledoc """
  A struct representing a Bluesky session.
  """

  alias BlueskyClient.{Credentials, RequestUtils}
  alias HTTPoison

  @type t :: %__MODULE__{
          pds: String.t(),
          access_token: String.t(),
          refresh_token: String.t(),
          did: String.t()
        }

  defstruct [:pds, :access_token, :refresh_token, :did]

  @spec create(Credentials.t(), String.t()) :: BlueskyClient.Session.t()
  def create(%Credentials{username: identifier, password: password}, pds) do
    uri = "#{pds}/xrpc/com.atproto.server.createSession"

    request_body =
      Jason.encode!(%{
        identifier: identifier,
        password: password
      })

    headers = RequestUtils.default_headers()
    {:ok, response} = HTTPoison.post(uri, request_body, headers)

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
