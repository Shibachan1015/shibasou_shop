defmodule ShibasouShop.OrdersTest do
  use ShibasouShop.DataCase
  @moduletag :legacy

  alias ShibasouShop.Orders

  describe "orders" do
    alias ShibasouShop.Orders.Order

    import ShibasouShop.OrdersFixtures

    @invalid_attrs %{status: nil, order_number: nil, customer_kind: nil, allow_backorder: nil, subtotal_cents: nil, tax_cents: nil, total_cents: nil, claim_cycle: nil, payment_terms: nil, note: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{status: "some status", order_number: "some order_number", customer_kind: "some customer_kind", allow_backorder: true, subtotal_cents: 42, tax_cents: 42, total_cents: 42, claim_cycle: "some claim_cycle", payment_terms: "some payment_terms", note: "some note"}

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.status == "some status"
      assert order.order_number == "some order_number"
      assert order.customer_kind == "some customer_kind"
      assert order.allow_backorder == true
      assert order.subtotal_cents == 42
      assert order.tax_cents == 42
      assert order.total_cents == 42
      assert order.claim_cycle == "some claim_cycle"
      assert order.payment_terms == "some payment_terms"
      assert order.note == "some note"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{status: "some updated status", order_number: "some updated order_number", customer_kind: "some updated customer_kind", allow_backorder: false, subtotal_cents: 43, tax_cents: 43, total_cents: 43, claim_cycle: "some updated claim_cycle", payment_terms: "some updated payment_terms", note: "some updated note"}

      assert {:ok, %Order{} = order} = Orders.update_order(order, update_attrs)
      assert order.status == "some updated status"
      assert order.order_number == "some updated order_number"
      assert order.customer_kind == "some updated customer_kind"
      assert order.allow_backorder == false
      assert order.subtotal_cents == 43
      assert order.tax_cents == 43
      assert order.total_cents == 43
      assert order.claim_cycle == "some updated claim_cycle"
      assert order.payment_terms == "some updated payment_terms"
      assert order.note == "some updated note"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
