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

  @spec create(Credentials, String.t()) :: BlueskyClient.Session.t()
  def create(credentials, pds) do
    uri = "#{pds}/xrpc/com.atproto.server.createSession"

    request_body =
      Jason.encode!(%{
        identifier: credentials.username,
        password: credentials.password
      })

    headers = RequestUtils.default_headers()
    {:ok, response} = HTTPoison.post(uri, request_body, headers)
    response_body = Jason.decode!(response.body)

    %__MODULE__{
      pds: pds,
      access_token: response_body["accessJwt"],
      refresh_token: response_body["refreshJwt"],
      did: response_body["did"]
    }
  end
end
