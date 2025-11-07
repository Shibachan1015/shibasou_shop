defmodule ShibasouShop.Catalog.Variant do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "variants" do
    field :sku, :string
    field :price_cents, :integer, default: 0
    field :compare_at_cents, :integer
    field :tax_included, :boolean, default: true
    # e.g. %{"Size" => "LL"}
    field :option_values, :map, default: %{}
    field :weight_g, :integer, default: 0
    field :status, :string, default: "active"

    belongs_to :product, ShibasouShop.Catalog.Product
    has_many :variant_components, ShibasouShop.BOM.VariantComponent
    has_many :components, through: [:variant_components, :component]
    has_many :inventory_levels, ShibasouShop.Inventory.InventoryLevel

    timestamps()
  end

  def changeset(variant, attrs) do
    variant
    |> cast(attrs, [
      :product_id,
      :sku,
      :price_cents,
      :compare_at_cents,
      :tax_included,
      :option_values,
      :weight_g,
      :status
    ])
    |> validate_required([:product_id, :status, :price_cents])
    |> validate_number(:price_cents, greater_than_or_equal_to: 0)
    |> validate_inclusion(:status, ["active", "inactive"])
    |> unique_constraint(:sku)
  end
end
