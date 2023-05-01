defmodule BlueskyEx.Client.RecordManager do
  @moduledoc """
  A module to namespace functions that interact with a Bluesky feed.
  """

  alias BlueskyEx.Client.{RequestUtils, Session}
  alias HTTPoison.Response

  @spec get_popular(Session.t(), Integer) :: Response.t()
  def get_popular(session, limit),
    do: fetch_data(:get_popular, session, query: %{"limit" => limit})

  @spec get_timeline(Session.t(), Integer) :: Response.t()
  def get_timeline(session, limit),
    do: fetch_data(:get_timeline, session, query: %{"limit" => limit})

  @spec get_profile(Session.t()) :: Response.t()
  def get_profile(session),
    do: fetch_data(:get_profile, session, query: %{"actor" => session.did})

  @spec create_post(Session.t(), String.t()) :: Response.t()
  def create_post(session, text),
    do:
      fetch_data(:create_record, session,
        body:
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
      )

  @type options :: [{:body, String.t()} | {:query, RequestUtils.URI.query_params()}]
  @spec fetch_data(atom(), Session.t(), options) :: Response.t()
  defp fetch_data(request_type, %Session{pds: pds} = session, options) do
    query = options[:query]
    body = options[:body]

    args =
      case query do
        nil -> [pds]
        _ -> [pds, query]
      end

    uri = apply(RequestUtils.URI, request_type, args)
    make_request(session, uri, body)
  end

  @spec make_request(Session.t(), String.t(), String.t()) :: Response.t()
  defp make_request(session, uri, body) do
    headers = RequestUtils.default_authenticated_headers(session)

    {:ok, response} =
      case body do
        nil -> HTTPoison.get(uri, headers)
        _ -> HTTPoison.post(uri, body, headers)
      end

    response
  end
end
