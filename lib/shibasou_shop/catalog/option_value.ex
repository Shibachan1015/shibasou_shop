defmodule ShibasouShop.Catalog.OptionValue do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "option_values" do
    field :value, :string
    belongs_to :option, ShibasouShop.Catalog.Option
    timestamps()
  end

  def changeset(ov, attrs) do
    ov
    |> cast(attrs, [:value, :option_id])
    |> validate_required([:value, :option_id])
    |> unique_constraint([:option_id, :value], name: :option_values_option_id_value_index)
  end
end
