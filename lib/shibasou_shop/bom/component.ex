defmodule ShibasouShop.BOM.Component do
  use Ecto.Schema
  import Ecto.Changeset

  schema "components" do
    field :code, :string
    field :kind, :string        # "hanao" | "ten" | "sole"
    field :size, :string
    field :attributes, :map, default: %{}

    has_many :component_stocks, ShibasouShop.Inventory.ComponentStock
    timestamps()
  end

  def changeset(comp, attrs) do
    comp
    |> cast(attrs, [:code, :kind, :size, :attributes])
    |> validate_required([:code, :kind])
    |> validate_inclusion(:kind, ["hanao","ten","sole"])
    |> unique_constraint(:code)
  end
end
