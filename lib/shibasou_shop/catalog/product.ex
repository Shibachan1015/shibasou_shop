defmodule ShibasouShop.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :title, :string
    field :slug, :string
    field :description, :string
    field :status, :string, default: "draft"
    field :tags, {:array, :string}, default: nil
    field :seo, :map, default: %{}
    field :attributes, :map, default: %{}

    has_many :options, ShibasouShop.Catalog.Option
    has_many :variants, ShibasouShop.Catalog.Variant
    has_many :media_assets, ShibasouShop.Catalog.MediaAsset

    has_many :collection_products, ShibasouShop.Catalog.CollectionProduct

    many_to_many :collections, ShibasouShop.Catalog.Collection,
      join_through: ShibasouShop.Catalog.CollectionProduct,
      join_keys: [product_id: :id, collection_id: :id]

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :slug, :description, :status, :tags, :seo, :attributes])
    |> validate_required([:title, :slug, :status])
    |> validate_inclusion(:status, ["draft", "active", "archived"])
    |> unique_constraint(:slug)
  end
end
