defmodule ShibasouShop.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ShibasouShop.Catalog` context.
  """

  @doc """
  Generate a ten.
  """
  def ten_fixture(attrs \\ %{}) do
    {:ok, ten} =
      attrs
      |> Enum.into(%{
        allocated_qty: 42,
        backordered_qty: 42,
        code: "some code",
        enabled: true,
        image_layer_url: "some image_layer_url",
        name: "some name",
        price_delta_cents: 42,
        stock_qty: 42
      })
      |> ShibasouShop.Catalog.create_ten()

    ten
  end

  @doc """
  Generate a outsole.
  """
  def outsole_fixture(attrs \\ %{}) do
    {:ok, outsole} =
      attrs
      |> Enum.into(%{
        allocated_qty: 42,
        backordered_qty: 42,
        code: "some code",
        enabled: true,
        image_layer_url: "some image_layer_url",
        name: "some name",
        price_delta_cents: 42,
        stock_qty: 42
      })
      |> ShibasouShop.Catalog.create_outsole()

    outsole
  end

  @doc """
  Generate a hanao.
  """
  def hanao_fixture(attrs \\ %{}) do
    {:ok, hanao} =
      attrs
      |> Enum.into(%{
        allocated_qty: 42,
        backordered_qty: 42,
        code: "some code",
        enabled: true,
        image_layer_url: "some image_layer_url",
        name: "some name",
        price_delta_cents: 42,
        stock_qty: 42
      })
      |> ShibasouShop.Catalog.create_hanao()

    hanao
  end
end
