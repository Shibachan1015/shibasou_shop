defmodule ShibasouShopWeb.Plugs.ContentSecurityPolicy do
  @moduledoc """
  Plug to set Content-Security-Policy header for security.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    csp_policy =
      [
        "default-src 'self'",
        "script-src 'self' 'unsafe-inline' 'unsafe-eval'",
        "style-src 'self' 'unsafe-inline'",
        "img-src 'self' data: https:",
        "font-src 'self' data:",
        "connect-src 'self'",
        "frame-ancestors 'none'",
        "base-uri 'self'",
        "form-action 'self'"
      ]
      |> Enum.join("; ")

    conn
    |> put_resp_header("content-security-policy", csp_policy)
  end
end
