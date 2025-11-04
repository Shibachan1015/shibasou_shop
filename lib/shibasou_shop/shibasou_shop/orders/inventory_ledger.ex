defmodule ShibasouShop.ShibasouShop.Orders.InventoryLedger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory_ledgers" do
    field :part_type, :string
    field :part_id, :integer
    field :change_qty, :integer
    field :reason, :string
    field :note, :string
    field :order_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory_ledger, attrs) do
    inventory_ledger
    |> cast(attrs, [:part_type, :part_id, :change_qty, :reason, :note])
    |> validate_required([:part_type, :part_id, :change_qty, :reason, :note])
  end
end
