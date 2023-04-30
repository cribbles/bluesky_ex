defmodule BlueskyClient.RecordManager do
  @moduledoc """
  A module to namespace functions that interact with a Bluesky feed.
  """

  alias BlueskyClient.{RequestUtils, Session}
  alias HTTPoison

  @spec create_post(Session.t(), String.t()) :: HTTPoison.Response.t()
  def create_post(%Session{pds: pds} = session, text) do
    args =
      Jason.encode!(%{
        "collection" => "app.bsky.feed.post",
        "$type" => "com.atproto.repo.createRecord",
        "repo" => session.did,
        "record" => %{
          "$type" => "app.bsky.feed.post",
          "createdAt" => DateTime.utc_now() |> DateTime.to_iso8601(),
          "text" => text
        }
      })

    uri = RequestUtils.URI.create_record(pds)
    headers = RequestUtils.default_authenticated_headers(session)
    {:ok, response} = HTTPoison.post(uri, args, headers)
    response
  end

  @spec get_popular(Session.t(), Integer) :: HTTPoison.Response.t()
  def get_popular(%Session{pds: pds} = session, n) do
    query = %{"limit" => n}
    uri = RequestUtils.URI.get_popular(pds, query)
    headers = RequestUtils.default_authenticated_headers(session)
    {:ok, response} = HTTPoison.get(uri, headers)
    response
  end
end
