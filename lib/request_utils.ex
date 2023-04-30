defmodule BlueskyClient.RequestUtils do
  @moduledoc """
  A module to namespace HTTP-related functions.
  """

  alias HTTPoison

  @spec query_obj_to_query_params(any) :: nonempty_binary
  def query_obj_to_query_params(query) do
    query
    |> Enum.reject(fn {_, value} -> value == nil or value == "" end)
    |> Enum.map_join("&", fn {key, value} -> "#{key}=#{value}" end)
    |> (&"?#{&1}").()
  end

  @spec get_popular_uri(String.t(), any) :: String.t()
  def get_popular_uri(pds, query) do
    "#{pds}/xrpc/app.bsky.unspecced.getPopular#{query_obj_to_query_params(query)}"
  end

  @spec get_create_post_uri(String.t()) :: String.t()
  def get_create_post_uri(pds) do
    "#{pds}/xrpc/com.atproto.repo.createRecord"
  end

  @spec default_headers :: [{String.t(), String.t()}]
  def default_headers do
    [{"Content-Type", "application/json"}]
  end

  @spec default_authenticated_headers(BlueskyClient.Session.t()) :: [
          {String.t(), String.t()},
          ...
        ]
  def default_authenticated_headers(%BlueskyClient.Session{access_token: access_token}) do
    [{"Authorization", "Bearer #{access_token}"} | default_headers()]
  end
end
