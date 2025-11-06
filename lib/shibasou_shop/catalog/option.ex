defmodule ShibasouShop.Catalog.Option do
  use Ecto.Schema
  import Ecto.Changeset

  schema "options" do
    field :name, :string
    belongs_to :product, ShibasouShop.Catalog.Product
    has_many :option_values, ShibasouShop.Catalog.OptionValue
    timestamps()
  end

  def changeset(option, attrs) do
    option
    |> cast(attrs, [:name, :product_id])
    |> validate_required([:name, :product_id])
  end
end
