defmodule ShibasouShop.Catalog.SKU do
  @moduledoc false
  @template "{PROD}-{SIZE}"

  @spec build(String.t(), map()) :: String.t()
  def build(prod_slug, opts_map) do
    size = Map.get(opts_map, "Size") || Map.get(opts_map, :Size) || "NA"

    @template
    |> String.replace("{PROD}", String.upcase(prod_slug))
    |> String.replace("{SIZE}", size)
  end
end
