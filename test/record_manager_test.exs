defmodule BlueskyEx.Client.RecordManagerTest do
  use ExUnit.Case
  import Mox

  # Set up Mox to use our MockRequestUtils
  setup :set_mox_global
  setup :verify_on_exit!

  alias BlueskyEx.Client.{RecordManager, Session}
  alias HTTPoison.Response
  alias MockRequestUtils, as: RequestUtils

  @session %Session{
    did: "did:bsky:0000",
    pds: :feed,
    access_token: "test_token"
  }

  @feed_query_opts [
    limit: 5,
    algorithm: "reverse-chronological"
  ]

  # Define a helper function to create a stubbed response
  defp stub_response do
    %Response{status_code: 200, body: "{}"}
  end

  describe "get_account_invite_codes" do
    test "returns a response" do
      RequestUtils
      |> expect(:get_account_invite_codes, fn _pds -> stub_response() end)
      |> expect(:make_request, fn _uri, _options -> stub_response() end)

      response = RecordManager.get_account_invite_codes(@session)

      assert %Response{} = response
    end
  end

  # ... (Repeat this pattern for the remaining tests)
end
