defmodule ShibasouShop.Inventory.InventoryLevel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory_levels" do
    field :qty_on_hand, :integer, default: 0
    field :qty_reserved, :integer, default: 0
    field :low_stock_threshold, :integer

    belongs_to :variant, ShibasouShop.Catalog.Variant
    belongs_to :location, ShibasouShop.Inventory.Location
    timestamps()
  end

  def changeset(il, attrs) do
    il
    |> cast(attrs, [:variant_id, :location_id, :qty_on_hand, :qty_reserved, :low_stock_threshold])
    |> validate_required([:variant_id, :location_id])
    |> validate_number(:qty_on_hand, greater_than_or_equal_to: 0)
    |> validate_number(:qty_reserved, greater_than_or_equal_to: 0)
    |> unique_constraint([:variant_id, :location_id],
      name: :inventory_levels_variant_id_location_id_index
    )
  end
end
