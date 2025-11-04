defmodule ShibasouShop.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ShibasouShop.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        allow_backorder: true,
        claim_cycle: "some claim_cycle",
        customer_kind: "some customer_kind",
        note: "some note",
        order_number: "some order_number",
        payment_terms: "some payment_terms",
        status: "some status",
        subtotal_cents: 42,
        tax_cents: 42,
        total_cents: 42
      })
      |> ShibasouShop.Orders.create_order()

    order
  end
end
