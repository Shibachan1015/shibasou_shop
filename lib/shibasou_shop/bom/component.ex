defmodule ShibasouShop.BOM.Component do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer() | nil,
          code: String.t() | nil,
          kind: String.t() | nil,
          size: String.t() | nil,
          attributes: map(),
          component_stocks: Ecto.Association.NotLoaded.t() | [ShibasouShop.Inventory.ComponentStock.t()],
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  schema "components" do
    field :code, :string
    # "hanao" | "ten" | "sole"
    field :kind, :string
    field :size, :string
    field :attributes, :map, default: %{}

    has_many :component_stocks, ShibasouShop.Inventory.ComponentStock
    timestamps()
  end

  def changeset(comp, attrs) do
    comp
    |> cast(attrs, [:code, :kind, :size, :attributes])
    |> validate_required([:code, :kind])
    |> validate_inclusion(:kind, ["hanao", "ten", "sole"])
    |> unique_constraint(:code)
  end
end
