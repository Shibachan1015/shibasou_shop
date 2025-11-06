了解！`shibasou_shop` リポの中身（Docker 前提の Phoenix 雛形）を踏まえて、**いまのDB方針（完成品＝Variant ＋ BOM で鼻緒/天/底を紐づけ、サイズは直積で自動生成）**を Cursor のエージェントに伝えるための “投入用ブリーフ” を作りました。これをそのまま貼ってください。

---

# Cursor Agent Brief — shibasou_shop

## 0) リポ前提

* リポ: `Shibachan1015/shibasou_shop`（Phoenix 1.7系 / Docker Compose で起動）

  * 開発手順・Composeの役割は README に記載（DB ホスト名は `db`、QuickStart コマンドあり）。([GitHub][1])
* コード追加は **このリポ内**で行う。ビルド/実行は README 記載のコマンドに準拠。([GitHub][1])

## 1) ドメイン要件（このプロジェクト専用）

* 完成品（販売単位）は **Variant**。**固有ID/完成SKU** を必ず持つ（部品IDの合成を主キーにしない）。
* 3部品（**鼻緒 / 天 / 底**）は **Component** として独立管理し、**VariantComponents（BOM）** で Variant に紐づける。
* **サイズ**は `Size = {S, M, L, LL, 3L, 4L}` のオプションとして管理。**バリアント自動生成（直積）**で各サイズの完成品を作る。
* 在庫運用は商品単位でモード選択：

  * `assemble_on_order`（受注組み）：出荷時に **部品在庫**を引当/減算
  * `preassembled`（先組み）：**完成品在庫**を引当/減算（組立時に部品在庫を消化）
* SKUはテンプレ（例：`{PROD}-{SIZE}-{HNA}-{TEN}-{SOL}`）から**自動生成**し、ユニーク制約。主キーはサロゲート。

## 2) データモデル（Phase 1 最小）

**サロゲート主キー（id）／PostgreSQL／Ecto**

```
products(id, title, slug, description, status, tags:text[], seo:jsonb, attributes:jsonb)

options(id, product_id, name)                    -- "Size"
option_values(id, option_id, value)              -- S,M,L,LL,3L,4L

variants(id, product_id, sku, price_cents, compare_at_cents,
         tax_included, option_values:jsonb, weight_g, status)

components(id, code, kind, size, attributes:jsonb)         -- kind: "hanao"|"ten"|"sole"
component_stocks(id, component_id, location_id, qty_on_hand, qty_reserved)

variant_components(variant_id, component_id, qty, size_map:jsonb)   -- BOM (完成品↔部品)

locations(id, name, code)
inventory_levels(id, variant_id, location_id, qty_on_hand, qty_reserved, low_stock_threshold)

orders(id, order_number, status, totals:jsonb, customer_info:jsonb,
       shipping_rate:jsonb, payment:jsonb, placed_at, paid_at, fulfilled_at, cancelled_at)
order_items(id, order_id, variant_id, qty, price_cents)

events(id, topic, payload:jsonb, inserted_at)
```

## 3) トランザクション方針（整合性要）

* 注文確定：

  * `assemble_on_order`：BOM 展開 → **component_stocks を `SELECT ... FOR UPDATE`** → 在庫チェック → `qty_reserved` 加算 → OK なら `orders.status=placed`
  * `preassembled`：**inventory_levels** を同様にロック・引当
* 未入金タイムアウト/キャンセル：**予約解放（reserved 差戻し）**
* 出荷確定：**qty_on_hand 減算 + reserved 相殺**
* **並行購入の衝突テスト**（同SKU/同時）を必ず用意。

## 4) 画面（LiveView）スコープ

* **Admin / Products**：基本・メディアD&D・**オプション→バリアント自動生成**・価格/在庫・コレクション（手動）・SEO
* **Admin / Inventory**：ロケーション×SKU グリッド編集
* **Admin / Orders**：一覧/詳細（支払/出荷CSV/メール）
* **Storefront**：一覧→詳細→カート→チェックアウト（銀行振込/代引）
* **CSV**：商品/バリアント/在庫の I/O

## 5) 実装順（このリポで動かす）

1. **マイグレーション**：上記テーブル（Phase1は `inventory_movements` 省略可）
2. **Ecto スキーマ/Changeset**：Product/Option/OptionValue/Variant/Component/VariantComponent/Inventory/Order
3. **Catalog サービス**

   * **バリアント自動生成**（`Size` 直積）
   * **SKU 自動生成**（テンプレ適用、手修正可）
   * **BOM 自動割当**（サイズに応じた部品を規則で紐づけ）
4. **Inventory サービス**

   * 引当/解放/出荷（部品 or 完成品モード）
   * `SELECT ... FOR UPDATE` を用いた競合制御
5. **LiveView**

   * Admin Products：上記 UI（ハッピーパス）
   * Inventory グリッド／Orders 最低限
6. **テスト**

   * ユニット（changeset/サービス）
   * **在庫引当の並行テスト**（最重要）
   * LiveView ハッピーパス
7. **イベント**：`order.created` / `stock.changed` を `Phoenix.PubSub` で発火
8. **CI（GitHub Actions）**：`format/credo/dialyzer/sobelow/test` を Quality Gate（README の Docker 前提で問題なし）。([GitHub][1])

## 6) リポ運用（Docker 前提）

* 起動手順：README の **QuickStart（compose）→ deps.get → ecto.create/migrate** を踏む。([GitHub][1])
* DB 接続は **hostname: "db"** で構成（`config/dev.exs` 記載）。([GitHub][1])
* よく使う `docker compose` のチートシート／トラブルシュートは README を参照（port 4000 競合、権限、起動順など）。([GitHub][1])

## 7) Done の判定

* Admin から **ノーコードで** 商品登録 → **サイズ直積の Variant 自動生成** → 在庫編集 → 受注 → 出荷CSV まで実行可能
* `assemble_on_order` / `preassembled` の両モードで在庫整合が保たれる（並行テスト合格）
* CI（format/credo/dialyzer/sobelow/test）全緑

---

### 参考（リポ README 抜粋）

* QuickStart / ディレクトリ / Docker 設定の要点・Compose 断片は README にまとまっているので遵守。([GitHub][1])
* 「次にやること」には **“天/鼻緒/底のスキーマ設計” と “Orders.allocate の骨子”** などが既に TODO として記載されている。今回の指示はそれを**BOM＋在庫引当**として具体化するもの。([GitHub][1])

---

必要なら、このブリーフを**英語版**にも即変換します。

[1]: https://github.com/Shibachan1015/shibasou_shop "GitHub - Shibachan1015/shibasou_shop"
