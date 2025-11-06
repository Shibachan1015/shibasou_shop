defmodule ShibasouShop.Inventory.ComponentStock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "component_stocks" do
    field :qty_on_hand, :integer, default: 0
    field :qty_reserved, :integer, default: 0
    belongs_to :component, ShibasouShop.BOM.Component
    belongs_to :location, ShibasouShop.Inventory.Location
    timestamps()
  end

  def changeset(cs, attrs) do
    cs
    |> cast(attrs, [:component_id, :location_id, :qty_on_hand, :qty_reserved])
    |> validate_required([:component_id, :location_id])
    |> validate_number(:qty_on_hand, greater_than_or_equal_to: 0)
    |> validate_number(:qty_reserved, greater_than_or_equal_to: 0)
    |> unique_constraint([:component_id, :location_id],
      name: :component_stocks_component_id_location_id_index
    )
  end
end
