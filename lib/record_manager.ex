defmodule BlueskyEx.Client.RecordManager do
  @moduledoc """
  A module to namespace functions that interact with a Bluesky feed.
  """

  alias BlueskyEx.Client.{RequestUtils, Session}
  alias HTTPoison.Response

  @spec get_account_invite_codes(Session.t()) :: Response.t()
  def get_account_invite_codes(session),
    do: fetch_data(:get_account_invite_codes, session)

  @spec get_notifications(Session.t(), Keyword.t()) :: Response.t()
  def get_notifications(session, opts \\ []),
    do: fetch_data(:get_notifications, session, query: build_feed_query(opts))

  @spec get_popular(Session.t(), Keyword.t()) :: Response.t()
  def get_popular(session, opts \\ []),
    do: fetch_data(:get_popular, session, query: build_feed_query(opts))

  @spec get_timeline(Session.t(), Keyword.t()) :: Response.t()
  def get_timeline(session, opts \\ []),
    do: fetch_data(:get_timeline, session, query: build_feed_query(opts))

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
  defp fetch_data(request_type, %Session{pds: pds} = session, options \\ []) do
    query = options[:query]
    body = options[:body]

    args =
      case query do
        nil -> [pds]
        _ -> [pds, query]
      end

    uri = apply(RequestUtils.URI, request_type, args)
    RequestUtils.make_request(uri, body, session)
  end

  @spec build_feed_query(Keyword.t()) :: RequestUtils.URI.query_params()
  defp build_feed_query(opts) do
    algorithm = Keyword.get(opts, :algorithm, "reverse-chronological")
    limit = Keyword.get(opts, :limit, 30)

    %{"limit" => limit, "algorithm" => algorithm}
  end
end
