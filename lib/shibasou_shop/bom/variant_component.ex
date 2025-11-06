defmodule ShibasouShop.BOM.VariantComponent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "variant_components" do
    field :qty, :integer, default: 1
    field :size_map, :map, default: %{}
    belongs_to :variant, ShibasouShop.Catalog.Variant, primary_key: true
    belongs_to :component, ShibasouShop.BOM.Component, primary_key: true
  end

  def changeset(vc, attrs) do
    vc
    |> cast(attrs, [:variant_id, :component_id, :qty, :size_map])
    |> validate_required([:variant_id, :component_id, :qty])
    |> validate_number(:qty, greater_than: 0)
    |> unique_constraint([:variant_id, :component_id],
      name: :variant_components_variant_id_component_id_index
    )
  end
end
