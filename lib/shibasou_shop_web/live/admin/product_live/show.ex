defmodule ShibasouShopWeb.Admin.ProductLive.Show do
  use ShibasouShopWeb, :live_view
  alias ShibasouShop.Catalog.{Generator, Product}
  alias ShibasouShop.Repo

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, socket |> assign_product(id) |> assign(:page_title, "Admin · Product")}
  end

  defp assign_product(socket, id) do
    product =
      Repo.get!(Product, id)
      |> Repo.preload(:variants)

    socket
    |> assign(:product, product)
    |> assign(:variants, product.variants)
  end

  @impl true
  def handle_event("gen_variants", _params, socket) do
    product = socket.assigns.product

    case Generator.generate_size_variants(product.id) do
      {:ok, {:ok, _new_variants}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Variants generated/updated")
         |> assign_product(product.id)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Failed: #{inspect(reason)}")}

      other ->
        {:noreply, put_flash(socket, :error, "Unexpected: #{inspect(other)}")}
    end
  end
end
