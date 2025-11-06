defmodule ShibasouShop.Catalog.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collections" do
    field :name, :string
    field :handle, :string
    field :type, :string        # "manual" | "auto"
    field :rules, :map, default: %{}

    has_many :collection_products, ShibasouShop.Catalog.CollectionProduct
    many_to_many :products, ShibasouShop.Catalog.Product,
      join_through: ShibasouShop.Catalog.CollectionProduct,
      join_keys: [collection_id: :id, product_id: :id]

    timestamps()
  end

  def changeset(col, attrs) do
    col
    |> cast(attrs, [:name, :handle, :type, :rules])
    |> validate_required([:name, :handle, :type])
    |> validate_inclusion(:type, ["manual", "auto"])
    |> unique_constraint(:handle, name: :collections_handle_index)
  end
end
