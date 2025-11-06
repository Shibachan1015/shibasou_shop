defmodule ShibasouShop.Inventory.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :name, :string
    field :code, :string
    has_many :inventory_levels, ShibasouShop.Inventory.InventoryLevel
    has_many :component_stocks, ShibasouShop.Inventory.ComponentStock
    timestamps()
  end

  def changeset(loc, attrs) do
    loc
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
    |> unique_constraint(:code)
  end
end
