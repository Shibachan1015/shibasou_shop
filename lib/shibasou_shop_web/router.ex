# lib/shibasou_shop_web/router.ex
defmodule ShibasouShopWeb.Router do
  use ShibasouShopWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ShibasouShopWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_content_security_policy
  end

  defp put_content_security_policy(conn, _opts) do
    csp_policy =
      "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' ws: wss:; frame-ancestors 'self';"

    conn
    |> put_resp_header("content-security-policy", csp_policy)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShibasouShopWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShibasouShopWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:shibasou_shop, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/admin", ShibasouShopWeb do
      pipe_through :browser
      live "/products/:id", Admin.ProductLive.Show, :show
    end

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ShibasouShopWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
