defmodule ShibasouShop.Repo.Migrations.Phase1Core do
  use Ecto.Migration

  def change do
    # Clean up legacy tables if they exist (idempotent for fresh setups)
    drop_if_exists table(:ten_hanao_compat)
    drop_if_exists table(:ten_outsole_compat)
    drop_if_exists table(:inventory_ledgers)
    drop_if_exists table(:order_items)
    drop_if_exists table(:orders)
    drop_if_exists table(:tens)
    drop_if_exists table(:outsoles)
    drop_if_exists table(:hanaos)

    # Core catalog: products
    create table(:products) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :description, :text
      # draft | active | archived
      add :status, :string, null: false, default: "draft"
      add :tags, :text
      add :seo, :map
      add :attributes, :map
      # assemble_on_order | preassembled
      add :inventory_mode, :string, null: false, default: "preassembled"
      timestamps()
    end

    create unique_index(:products, [:slug])

    create constraint(:products, :products_status_chk,
             check: "status IN ('draft','active','archived')"
           )

    create constraint(:products, :products_inventory_mode_chk,
             check: "inventory_mode IN ('assemble_on_order','preassembled')"
           )

    # Options (e.g., Size)
    create table(:options) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :name, :string, null: false
      timestamps()
    end
    create index(:options, [:product_id])

    create table(:option_values) do
      add :option_id, references(:options, on_delete: :delete_all), null: false
      add :value, :string, null: false
      add :position, :integer, null: false, default: 0
      timestamps()
    end

    create index(:option_values, [:option_id])
    create unique_index(:option_values, [:option_id, :value])

    # Variants (sellable unit)
    create table(:variants) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :sku, :string, null: false
      add :price_cents, :integer, null: false, default: 0
      add :compare_at_cents, :integer
      add :tax_included, :boolean, null: false, default: true
      # snapshot of selected option values, e.g., %{"Size" => "M"}
      add :option_values, :map
      add :weight_g, :integer
      # active | archived
      add :status, :string, null: false, default: "active"
      timestamps()
    end

    create index(:variants, [:product_id])
    create unique_index(:variants, [:sku])
    create constraint(:variants, :variants_status_chk, check: "status IN ('active','archived')")

    # Media assets for products
    create table(:media_assets) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      # image | video (future)
      add :kind, :string, null: false, default: "image"
      add :url, :string, null: false
      add :alt_text, :string
      add :position, :integer, null: false, default: 0
      timestamps()
    end

    create index(:media_assets, [:product_id])

    # Components (hanao / ten / sole)
    create table(:components) do
      add :code, :string, null: false
      # "hanao" | "ten" | "sole"
      add :kind, :string, null: false
      add :size, :string
      add :attributes, :map
      timestamps()
    end

    create unique_index(:components, [:code])
    create constraint(:components, :components_kind_chk, check: "kind IN ('hanao','ten','sole')")

    # Locations
    create table(:locations) do
      add :name, :string, null: false
      add :code, :string, null: false
      timestamps()
    end
    create unique_index(:locations, [:code])

    # Component stocks by location
    create table(:component_stocks) do
      add :component_id, references(:components, on_delete: :delete_all), null: false
      add :location_id, references(:locations, on_delete: :delete_all), null: false
      add :qty_on_hand, :integer, null: false, default: 0
      add :qty_reserved, :integer, null: false, default: 0
      timestamps()
    end

    create unique_index(:component_stocks, [:component_id, :location_id])

    create constraint(:component_stocks, :component_stocks_nonneg_chk,
             check: "qty_on_hand >= 0 AND qty_reserved >= 0"
           )

    # Variant BOM: finished good -> components
    create table(:variant_components, primary_key: false) do
      add :variant_id, references(:variants, on_delete: :delete_all), null: false
      add :component_id, references(:components, on_delete: :delete_all), null: false
      add :qty, :integer, null: false, default: 1
      # optional mapping for size-dependent components
      add :size_map, :map
    end

    create unique_index(:variant_components, [:variant_id, :component_id])
    create constraint(:variant_components, :variant_components_qty_pos_chk, check: "qty > 0")

    # Finished goods inventory by location
    create table(:inventory_levels) do
      add :variant_id, references(:variants, on_delete: :delete_all), null: false
      add :location_id, references(:locations, on_delete: :delete_all), null: false
      add :qty_on_hand, :integer, null: false, default: 0
      add :qty_reserved, :integer, null: false, default: 0
      add :low_stock_threshold, :integer
      timestamps()
    end

    create unique_index(:inventory_levels, [:variant_id, :location_id])

    create constraint(:inventory_levels, :inventory_levels_nonneg_chk,
             check: "qty_on_hand >= 0 AND qty_reserved >= 0"
           )

    # Collections and product membership
    create table(:collections) do
      add :name, :string, null: false
      add :handle, :string, null: false
      # manual | auto (future)
      add :type, :string, null: false, default: "manual"
      add :rules, :map
      timestamps()
    end

    create unique_index(:collections, [:handle])
    create constraint(:collections, :collections_type_chk, check: "type IN ('manual','auto')")

    create table(:collection_products) do
      add :collection_id, references(:collections, on_delete: :delete_all), null: false
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :position, :integer, null: false, default: 0
      timestamps()
    end

    create unique_index(:collection_products, [:collection_id, :product_id])

    # Orders (new schema per brief)
    create table(:orders) do
      add :order_number, :string, null: false
      # pending | placed | paid | fulfilled | cancelled
      add :status, :string, null: false, default: "pending"
      add :totals, :map
      add :customer_info, :map
      add :shipping_rate, :map
      add :payment, :map
      add :placed_at, :utc_datetime
      add :paid_at, :utc_datetime
      add :fulfilled_at, :utc_datetime
      add :cancelled_at, :utc_datetime
      timestamps()
    end

    create unique_index(:orders, [:order_number])

    create constraint(:orders, :orders_status_chk,
             check: "status IN ('pending','placed','paid','fulfilled','cancelled')"
           )

    create table(:order_items) do
      add :order_id, references(:orders, on_delete: :delete_all), null: false
      add :variant_id, references(:variants), null: false
      add :qty, :integer, null: false
      add :price_cents, :integer, null: false, default: 0
      timestamps()
    end

    create index(:order_items, [:order_id])
    create constraint(:order_items, :order_items_qty_pos_chk, check: "qty > 0")

    # Domain events (append-only)
    create table(:events) do
      add :topic, :string, null: false
      add :payload, :map, null: false
      timestamps(updated_at: false)
    end

    create index(:events, [:topic])
  end
end
