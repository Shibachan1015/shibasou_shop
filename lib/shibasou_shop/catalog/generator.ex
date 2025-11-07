defmodule ShibasouShop.Catalog.Generator do
  @moduledoc """
  Variant auto-generation from Option/OptionValues (Size only for MVP).
  """
  import Ecto.Query, warn: false
  alias ShibasouShop.Catalog.{Option, OptionValue, Product, Variant}
  alias ShibasouShop.Catalog.SKU
  alias ShibasouShop.Repo

  @doc """
  Generate size variants for a product from its `Size` option.

  - Skips sizes that already exist in variants (by option_values["Size"])
  - Assigns SKU via template `{PROD}-{SIZE}`
  """
  @spec generate_size_variants(product_id :: integer) ::
          {:ok, [Variant.t()]} | {:error, term}
  def generate_size_variants(product_id) when is_integer(product_id) do
    Repo.transaction(fn ->
      product = Repo.get!(Product, product_id)

      size_opt =
        Repo.one!(
          from o in Option,
            where: o.product_id == ^product_id and o.name == "Size"
        )

      values =
        Repo.all(
          from v in OptionValue,
            where: v.option_id == ^size_opt.id,
            order_by: v.value
        )

      existing_sizes =
        Repo.all(
          from vr in Variant,
            where: vr.product_id == ^product_id,
            select: fragment("(?)::jsonb ->> 'Size'", vr.option_values)
        )
        |> MapSet.new()

      new_changesets =
        for %{value: size} <- values,
            not MapSet.member?(existing_sizes, size) do
          opts_map = %{"Size" => size}

          %Variant{}
          |> Variant.changeset(%{
            product_id: product.id,
            option_values: opts_map,
            status: "active",
            price_cents: 0,
            tax_included: true,
            weight_g: 0,
            sku: SKU.build(product.slug, opts_map)
          })
        end

      results = Enum.map(new_changesets, &Repo.insert/1)

      all_ok? = Enum.all?(results, fn r -> match?({:ok, _}, r) end)

      if all_ok? do
        {:ok, Enum.map(results, fn {:ok, v} -> v end)}
      else
        Repo.rollback(results)
      end
    end)
  end
end
