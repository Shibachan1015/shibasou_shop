defmodule ShibasouShopWeb.PageController do
  use ShibasouShopWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
