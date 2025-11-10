defmodule ShibasouShop.Catalog.CollectionProduct do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "collection_products" do
    field :position, :integer
    belongs_to :collection, ShibasouShop.Catalog.Collection
    belongs_to :product, ShibasouShop.Catalog.Product
    timestamps()
  end

  def changeset(cp, attrs) do
    cp
    |> cast(attrs, [:collection_id, :product_id, :position])
    |> validate_required([:collection_id, :product_id])
    |> unique_constraint([:collection_id, :product_id],
      name: :collection_products_collection_id_product_id_index
    )
  end
end
