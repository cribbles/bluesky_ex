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

  defmodule URI do
    @moduledoc """
    A module to namespace functions that generate an AT URI.
    """

    @spec create_session(String.t()) :: String.t()
    def create_session(pds) do
      "#{pds}/xrpc/com.atproto.server.createSession"
    end

    @spec get_popular(String.t(), any) :: String.t()
    def get_popular(pds, query) do
      "#{pds}/xrpc/app.bsky.unspecced.getPopular#{query_obj_to_query_params(query)}"
    end

    @spec get_timeline(String.t(), any) :: String.t()
    def get_timeline(pds, query) do
      "#{pds}/xrpc/app.bsky.feed.getTimeline#{query_obj_to_query_params(query)}"
    end

    @spec create_record(String.t()) :: String.t()
    def create_record(pds) do
      "#{pds}/xrpc/com.atproto.repo.createRecord"
    end

    @spec query_obj_to_query_params(any) :: String.t()
    defp query_obj_to_query_params(query) do
      query
      |> Enum.reject(fn {_, value} -> value == nil or value == "" end)
      |> Enum.map_join("&", fn {key, value} -> "#{key}=#{value}" end)
      |> (&"?#{&1}").()
    end
  end
end
