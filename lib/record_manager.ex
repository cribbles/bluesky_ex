defmodule BlueskyEx.Client.RecordManager.FetchBuilder do
  @moduledoc """
  A helper module to provide generator functions for RecordManager.
  """

  alias BlueskyEx.Client.Session
  alias HTTPoison.Response

  @type query_opt :: {:query, (Session.t(), Keyword.t() -> any()) | nil}
  @type body_opt :: {:body, (Session.t(), Keyword.t() -> String.t()) | nil}
  @type macro_opts :: [query_opt | body_opt]

  @spec create_fetch_function(atom(), Macro.t(), macro_opts) :: any()
  defmacro create_fetch_function(func, func_opts_type \\ [], opts \\ []) do
    query_fn = Keyword.get(opts, :query, nil)
    body_fn = Keyword.get(opts, :body, nil)
    endpoint = Keyword.get(opts, :endpoint, func)

    quote do
      @spec unquote(func)(Session.t(), unquote(func_opts_type)) :: Response.t()
      def unquote(func)(session, options \\ []) do
        query = generate_fn(unquote(query_fn), session, options)
        body = generate_fn(unquote(body_fn), session, options)
        fetch_data(unquote(endpoint), session, query: query, body: body)
      end
    end
  end
end

defmodule BlueskyEx.Client.RecordManager do
  @moduledoc """
  A module to namespace functions that interact with a Bluesky feed.
  """

  alias BlueskyEx.Client.{RequestUtils, Session}
  alias HTTPoison.Response

  require BlueskyEx.Client.RecordManager.FetchBuilder
  import BlueskyEx.Client.RecordManager.FetchBuilder

  @type feed_query_opts :: [
          limit: non_neg_integer(),
          algorithm: String.t()
        ]
  @type post_query_opts :: [
          text: String.t()
        ]

  # Dialyzer has trouble with generated functions with query params for now.
  @dialyzer {:nowarn_function, get_notifications: 2}
  @dialyzer {:nowarn_function, get_popular: 2}
  @dialyzer {:nowarn_function, get_timeline: 2}

  # READ
  create_fetch_function(:get_account_invite_codes)
  create_fetch_function(:get_profile, [], query: &build_actor_query/2)
  create_fetch_function(:get_notifications, feed_query_opts, query: &build_feed_query/2)
  create_fetch_function(:get_popular, feed_query_opts, query: &build_feed_query/2)
  create_fetch_function(:get_timeline, feed_query_opts, query: &build_feed_query/2)

  # CREATE
  create_fetch_function(:create_post, post_query_opts,
    endpoint: :create_record,
    body: &build_post_body/2
  )

  @typep fetch_options :: [{:body, String.t()} | {:query, RequestUtils.URI.query_params()}]
  @spec fetch_data(atom(), Session.t(), fetch_options) :: Response.t()
  defp fetch_data(request_type, %Session{pds: pds} = session, options) do
    query = options[:query]
    body = options[:body]

    args =
      case query do
        nil -> [pds]
        _ -> [pds, query]
      end

    uri = apply(RequestUtils.URI, request_type, args)
    RequestUtils.make_request(uri, body: body, session: session)
  end

  @spec build_post_body(Session.t(), Keyword.t()) :: String.t()
  defp build_post_body(session, text: text) do
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
  end

  @spec build_feed_query(Session.t(), Keyword.t()) :: RequestUtils.URI.query_params()
  defp build_feed_query(_session, opts) do
    algorithm = Keyword.get(opts, :algorithm, "reverse-chronological")
    limit = Keyword.get(opts, :limit, 30)

    %{"limit" => limit, "algorithm" => algorithm}
  end

  @spec build_actor_query(Session.t(), Keyword.t()) :: RequestUtils.URI.query_params()
  defp build_actor_query(session, _opts) do
    %{"actor" => session.did}
  end

  @typep generator :: (Session.t(), Keyword.t() -> any())
  @spec generate_fn(generator | nil, Session.t(), Keyword.t()) :: any()
  defp generate_fn(generator, _session, _opts) when is_nil(generator), do: nil

  defp generate_fn(generator, session, opts) when is_function(generator, 2),
    do: generator.(session, opts)
end
