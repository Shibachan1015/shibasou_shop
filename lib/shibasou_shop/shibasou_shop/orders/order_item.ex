defmodule ShibasouShop.ShibasouShop.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field :qty, :integer
    field :unit_price_cents, :integer
    field :allocated_qty, :integer
    field :backordered_qty, :integer
    field :order_id, :id
    field :ten_id, :id
    field :hanao_id, :id
    field :outsole_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:qty, :unit_price_cents, :allocated_qty, :backordered_qty])
    |> validate_required([:qty, :unit_price_cents, :allocated_qty, :backordered_qty])
  end
end
