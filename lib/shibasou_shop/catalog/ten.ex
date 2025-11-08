defmodule ShibasouShop.Catalog.Ten do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tens" do
    field :code, :string
    field :name, :string
    field :price_delta_cents, :integer
    field :stock_qty, :integer
    field :allocated_qty, :integer
    field :backordered_qty, :integer
    field :image_layer_url, :string
    field :enabled, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ten, attrs) do
    ten
    |> cast(attrs, [
      :code,
      :name,
      :price_delta_cents,
      :stock_qty,
      :allocated_qty,
      :backordered_qty,
      :image_layer_url,
      :enabled
    ])
    |> validate_required([
      :code,
      :name,
      :price_delta_cents,
      :stock_qty,
      :allocated_qty,
      :backordered_qty,
      :image_layer_url,
      :enabled
    ])
  end
end
