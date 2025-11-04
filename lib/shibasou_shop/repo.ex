defmodule ShibasouShop.Repo do
  use Ecto.Repo,
    otp_app: :shibasou_shop,
    adapter: Ecto.Adapters.Postgres
end
