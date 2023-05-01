defmodule BlueskyEx.Client.RequestUtils do
  @moduledoc """
  A module to namespace HTTP-related functions.
  """

  alias HTTPoison

  @spec default_headers :: [{String.t(), String.t()}]
  def default_headers do
    [{"Content-Type", "application/json"}]
  end

  @spec default_authenticated_headers(BlueskyEx.Client.Session.t()) :: [
          {String.t(), String.t()},
          ...
        ]
  def default_authenticated_headers(%BlueskyEx.Client.Session{access_token: access_token}) do
    [{"Authorization", "Bearer #{access_token}"} | default_headers()]
  end

  defmodule URI.Builder do
    @moduledoc """
    A helper module to provide generator functions for RequestUtils.URI.
    """

    @spec build_uri(atom(), String.t(), list(atom())) :: any()
    defmacro build_uri(function_name, endpoint, params) do
      quote do
        case unquote(params) do
          [:pds, :query] ->
            @spec unquote(function_name)(pds :: String.t(), query :: query_params) :: uri
            def unquote(function_name)(pds, query) do
              build_base_uri(pds, unquote(endpoint)) <> query_obj_to_query_params(query)
            end

          _ ->
            @spec unquote(function_name)(pds :: String.t()) :: uri
            def unquote(function_name)(pds), do: build_base_uri(pds, unquote(endpoint))
        end
      end
    end
  end

  defmodule URI do
    @moduledoc """
    A module to namespace functions that generate an AT URI.
    """

    @type pds :: String.t()
    @type uri :: String.t()
    @type query_params :: %{String.t() => integer() | String.t()}

    require URI.Builder
    import URI.Builder

    # GET
    build_uri(:get_popular, "app.bsky.unspecced.getPopular", [:pds, :query])
    build_uri(:get_profile, "app.bsky.actor.getProfile", [:pds, :query])
    build_uri(:get_timeline, "app.bsky.feed.getTimeline", [:pds, :query])

    # POST
    build_uri(:create_record, "com.atproto.repo.createRecord", [:pds])
    build_uri(:create_session, "com.atproto.server.createSession", [:pds])

    @spec build_base_uri(pds, String.t()) :: uri
    defp build_base_uri(pds, endpoint), do: "#{pds}/xrpc/#{endpoint}"

    @spec query_obj_to_query_params(query_params) :: uri
    defp query_obj_to_query_params(query) do
      query
      |> Enum.reject(fn {_, value} -> value == nil or value == "" end)
      |> Enum.map_join("&", fn {key, value} -> "#{key}=#{value}" end)
      |> (&"?#{&1}").()
    end
  end
end
