defmodule BlueskyEx.Client.RecordManager do
  @moduledoc """
  A module to namespace functions that interact with a Bluesky feed.
  """

  alias BlueskyEx.Client.{RequestUtils, Session}
  alias HTTPoison.Response

  @type feed_query_opts :: [
          limit: non_neg_integer() | nil,
          algorithm: String.t() | nil
        ]

  @feed_query_defaults [
    limit: 30,
    algorithm: "reverse-chronological"
  ]

  @spec get_account_invite_codes(Session.t()) :: Response.t()
  def get_account_invite_codes(session),
    do: fetch_data(:get_account_invite_codes, session)

  @spec get_notifications(Session.t(), feed_query_opts) ::
          Response.t()
  def get_notifications(session, opts \\ []),
    do: fetch_data(:get_notifications, session, query: build_feed_query(opts))

  @spec get_popular(Session.t(), feed_query_opts) ::
          Response.t()
  def get_popular(session, opts \\ []),
    do: fetch_data(:get_popular, session, query: build_feed_query(opts))

  @spec get_timeline(Session.t(), feed_query_opts) ::
          Response.t()
  def get_timeline(session, opts \\ []),
    do: fetch_data(:get_timeline, session, query: build_feed_query(opts))

  @spec get_author_feed(Session.t(), actor: String.t() | feed_query_opts) :: Response.t()
  def get_author_feed(session, opts \\ []),
    do:
      fetch_data(:get_author_feed, session,
        query: Map.merge(build_feed_query(opts), build_actor_query(session))
      )

  @spec get_profile(Session.t(), actor: String.t() | nil) :: Response.t()
  def get_profile(session, opts \\ []),
    do: fetch_data(:get_profile, session, query: build_actor_query(session, opts))

  @spec create_post(Session.t(), text: String.t()) :: Response.t()
  def create_post(session, text: text),
    do:
      fetch_data(:create_record, session,
        body: build_create_body(session, "app.bsky.feed.post", %{text: text})
      )

  @spec delete_post(Session.t(), String.t()) :: Response.t()
  def delete_post(session, rkey),
    do:
      fetch_data(:delete_record, session,
        body: build_delete_body(session, "app.bsky.feed.post", rkey)
      )

  @spec create_like(Session.t(), uri: String.t(), cid: String.t()) :: Response.t()
  def create_like(session, uri: uri, cid: cid),
    do:
      fetch_data(:create_record, session,
        body: build_create_body(session, "app.bsky.feed.like", %{subject: %{uri: uri, cid: cid}})
      )

  @spec delete_like(Session.t(), String.t()) :: Response.t()
  def delete_like(session, rkey),
    do:
      fetch_data(:delete_record, session,
        body: build_delete_body(session, "app.bsky.feed.like", rkey)
      )

  @spec create_repost(Session.t(), uri: String.t(), cid: String.t()) :: Response.t()
  def create_repost(session, uri: uri, cid: cid),
    do:
      fetch_data(:create_record, session,
        body:
          build_create_body(session, "app.bsky.feed.repost", %{subject: %{uri: uri, cid: cid}})
      )

  @spec delete_repost(Session.t(), String.t()) :: Response.t()
  def delete_repost(session, rkey),
    do:
      fetch_data(:delete_record, session,
        body: build_delete_body(session, "app.bsky.feed.repost", rkey)
      )

  @typep fetch_options :: [
           {:body, String.t()}
           | {:query, RequestUtils.URI.query_params()}
         ]
  @spec fetch_data(atom(), Session.t(), fetch_options) :: Response.t()
  defp fetch_data(request_type, %Session{pds: pds} = session, options \\ []) do
    query = options[:query]
    body = options[:body]
    args = [pds | if(query != nil, do: [query], else: [])]
    uri = apply(RequestUtils.URI, request_type, args)
    RequestUtils.make_request(uri, body: body, session: session)
  end

  @spec build_create_body(Session.t(), String.t(), map()) :: String.t()
  defp build_create_body(session, type, fields) do
    Jason.encode!(%{
      collection: type,
      repo: session.did,
      record:
        Map.merge(
          %{
            "$type": type,
            createdAt: timestamp_now()
          },
          fields
        )
    })
  end

  @spec build_delete_body(Session.t(), String.t(), String.t()) :: String.t()
  defp build_delete_body(session, type, rkey) do
    Jason.encode!(%{
      collection: type,
      repo: session.did,
      rkey: rkey
    })
  end

  @spec timestamp_now :: String.t()
  defp timestamp_now do
    DateTime.utc_now() |> DateTime.to_iso8601()
  end

  @spec build_feed_query(feed_query_opts) :: RequestUtils.URI.query_params()
  defp build_feed_query(opts) do
    opts_map = Enum.into(opts, %{})
    default_map = Enum.into(@feed_query_defaults, %{})
    Map.merge(default_map, opts_map)
  end

  @spec build_actor_query(Session.t(), actor: String.t() | nil) :: RequestUtils.URI.query_params()
  defp build_actor_query(session, opts \\ []) do
    %{actor: opts[:actor] || session.did}
  end
end
