defmodule EzCoinsApiWeb.Plugs.Context do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  alias EzCoinsApi.Guardian

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Guardian.decode_and_verify(token),
         {:ok, user} <- Guardian.resource_from_claims(claims) do
      %{current_user: user}
    else
      _ -> %{sad: true}
    end
  end
end
