defmodule ShibasouShop.Catalog.MediaAsset do
  use Ecto.Schema
  import Ecto.Changeset

  schema "media_assets" do
    field :kind, :string
    field :url, :string
    field :alt_text, :string
    field :position, :integer
    belongs_to :product, ShibasouShop.Catalog.Product
    timestamps()
  end

  def changeset(ma, attrs) do
    ma
    |> cast(attrs, [:product_id, :kind, :url, :alt_text, :position])
    |> validate_required([:product_id, :kind, :url])
  end
end
