defmodule ShibasouShop.Repo.Migrations.InitPartsOrders do
  use Ecto.Migration

  def change do
    #
    # 1) パーツ3種：天 / 底材 / 鼻緒
    #
    create table(:tens) do
      # 管理コード（SKU相当）
      add :code, :string, null: false
      add :name, :string, null: false
      # 価格差額（ベース価格に加算）
      add :price_delta_cents, :integer, null: false, default: 0
      add :stock_qty, :integer, null: false, default: 0
      add :allocated_qty, :integer, null: false, default: 0
      add :backordered_qty, :integer, null: false, default: 0
      # レイヤー画像のURL（クライアント合成用）
      add :image_layer_url, :string
      add :enabled, :boolean, null: false, default: true
      timestamps()
    end

    create unique_index(:tens, [:code])

    create constraint(:tens, :tens_stock_nonnegative,
             check: "stock_qty >= 0 AND allocated_qty >= 0 AND backordered_qty >= 0"
           )

    create table(:outsoles) do
      add :code, :string, null: false
      add :name, :string, null: false
      add :price_delta_cents, :integer, null: false, default: 0
      add :stock_qty, :integer, null: false, default: 0
      add :allocated_qty, :integer, null: false, default: 0
      add :backordered_qty, :integer, null: false, default: 0
      add :image_layer_url, :string
      add :enabled, :boolean, null: false, default: true
      timestamps()
    end

    create unique_index(:outsoles, [:code])

    create constraint(:outsoles, :outsoles_stock_nonnegative,
             check: "stock_qty >= 0 AND allocated_qty >= 0 AND backordered_qty >= 0"
           )

    create table(:hanaos) do
      add :code, :string, null: false
      add :name, :string, null: false
      add :price_delta_cents, :integer, null: false, default: 0
      add :stock_qty, :integer, null: false, default: 0
      add :allocated_qty, :integer, null: false, default: 0
      add :backordered_qty, :integer, null: false, default: 0
      add :image_layer_url, :string
      add :enabled, :boolean, null: false, default: true
      timestamps()
    end

    create unique_index(:hanaos, [:code])

    create constraint(:hanaos, :hanaos_stock_nonnegative,
             check: "stock_qty >= 0 AND allocated_qty >= 0 AND backordered_qty >= 0"
           )

    #
    # 2) 互換制約（どの天 x 鼻緒／底材が組めるか）
    #
    create table(:ten_hanao_compat, primary_key: false) do
      add :ten_id, references(:tens, on_delete: :delete_all), null: false
      add :hanao_id, references(:hanaos, on_delete: :delete_all), null: false
    end

    create unique_index(:ten_hanao_compat, [:ten_id, :hanao_id])

    create table(:ten_outsole_compat, primary_key: false) do
      add :ten_id, references(:tens, on_delete: :delete_all), null: false
      add :outsole_id, references(:outsoles, on_delete: :delete_all), null: false
    end

    create unique_index(:ten_outsole_compat, [:ten_id, :outsole_id])

    #
    # 3) 受注（B2C/B2B）＋ 明細
    #    status: pending | allocated | partially_allocated | backordered | cancelled
    #    customer_kind: b2c | b2b
    #
    create table(:orders) do
      add :order_number, :string, null: false
      add :customer_kind, :string, null: false, default: "b2c"
      add :status, :string, null: false, default: "pending"
      add :allow_backorder, :boolean, null: false, default: false

      add :subtotal_cents, :integer, null: false, default: 0
      add :tax_cents, :integer, null: false, default: 0
      add :total_cents, :integer, null: false, default: 0

      # B2B請求関連（将来の締め処理で使用）
      # 例: "月末締め"
      add :claim_cycle, :string
      # 例: "翌月末"
      add :payment_terms, :string
      add :note, :text

      timestamps()
    end

    create unique_index(:orders, [:order_number])
    create constraint(:orders, :orders_customer_kind_chk, check: "customer_kind IN ('b2c','b2b')")

    create constraint(:orders, :orders_status_chk,
             check:
               "status IN ('pending','allocated','partially_allocated','backordered','cancelled')"
           )

    create table(:order_items) do
      add :order_id, references(:orders, on_delete: :delete_all), null: false
      add :ten_id, references(:tens), null: false
      add :hanao_id, references(:hanaos), null: false
      add :outsole_id, references(:outsoles), null: false

      add :qty, :integer, null: false
      add :unit_price_cents, :integer, null: false, default: 0

      # 引当の内訳（B2C: allocated=qty/BO=0, B2B: 部分引当あり）
      add :allocated_qty, :integer, null: false, default: 0
      add :backordered_qty, :integer, null: false, default: 0

      timestamps()
    end

    create index(:order_items, [:order_id])
    create constraint(:order_items, :order_items_qty_positive, check: "qty > 0")

    create constraint(:order_items, :order_items_alloc_nonneg,
             check: "allocated_qty >= 0 AND backordered_qty >= 0"
           )

    #
    # 4) 在庫台帳（仕入れ・調整・引当・出荷・返品などの履歴）
    #    part_type: ten | outsole | hanao
    #    reason: purchase | adjust | allocate | release | ship | return
    #
    create table(:inventory_ledgers) do
      add :part_type, :string, null: false
      # 参照先は part_type で分岐
      add :part_id, :bigint, null: false
      # +入庫 / -出庫
      add :change_qty, :integer, null: false
      add :reason, :string, null: false
      # 受注とのひもづけ（任意）
      add :order_id, references(:orders)
      add :note, :text
      timestamps(updated_at: false)
    end

    create index(:inventory_ledgers, [:order_id])
    create index(:inventory_ledgers, [:part_type, :part_id])

    create constraint(:inventory_ledgers, :ledgers_part_type_chk,
             check: "part_type IN ('ten','outsole','hanao')"
           )

    create constraint(:inventory_ledgers, :ledgers_reason_chk,
             check: "reason IN ('purchase','adjust','allocate','release','ship','return')"
           )
  end
end
