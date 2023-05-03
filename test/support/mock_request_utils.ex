defmodule MockRequestUtils do
  use Mox

  @behaviour BlueskyEx.Client.RequestUtils
  @behaviour BlueskyEx.Client.RequestUtils.URI

  defmock make_request(_uri, _options), do: :ok
  defmock get_account_invite_codes(_pds), do: :ok
  defmock get_profile(_pds, _query), do: :ok
  defmock get_notifications(_pds, _query), do: :ok
  defmock get_popular(_pds, _query), do: :ok
  defmock get_timeline(_pds, _query), do: :ok
  defmock create_record(_pds, _query), do: :ok
end
