defmodule ShibasouShop.Orders.Order do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :order_number, :string
    field :customer_kind, :string
    field :status, :string
    field :allow_backorder, :boolean, default: false
    field :subtotal_cents, :integer
    field :tax_cents, :integer
    field :total_cents, :integer
    field :claim_cycle, :string
    field :payment_terms, :string
    field :note, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :order_number,
      :customer_kind,
      :status,
      :allow_backorder,
      :subtotal_cents,
      :tax_cents,
      :total_cents,
      :claim_cycle,
      :payment_terms,
      :note
    ])
    |> validate_required([
      :order_number,
      :customer_kind,
      :status,
      :allow_backorder,
      :subtotal_cents,
      :tax_cents,
      :total_cents,
      :claim_cycle,
      :payment_terms,
      :note
    ])
  end
end
