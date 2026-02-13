# shibasou_shop — Progress Tracker

> Goal: Ship a **focused MVP** (sellable variants + BOM for parts + basic checkout) while laying foundations for future multi-brand rollout.

## 🔰 Legend
- ✅ Done　🟡 In Progress　⬜ Not Started
- Milestones close when **Definition of Done** (DoD) is met.

---

## 📈 Rollup (manual)
- Overall: **0%** (0 / 26)
- Last updated: YYYY-MM-DD (JST)

> Update by counting checked boxes below. (GitHub shows task progress per list automatically.)

---

## 🧭 Milestones

### M0 — Project Setup & Quality Gate
- [　] Create branch `feat/catalog-phase1`
- [　] Add GitHub Actions CI (format/credo/dialyzer/sobelow/test)
- [ ] Add dev tooling deps to `mix.exs` (credo/dialyxir/sobelow/mix_audit)
- [ ] CI green on a blank run (no tests yet)
- **DoD**: CI pipeline runs on PR and blocks merges when failing.

### M1 — Catalog & BOM (DB)
- [ ] Migration: `products`, `options`, `option_values`
- [ ] Migration: `variants` (sellable units; sku unique)
- [ ] Migration: `components` (hanao/ten/sole), `variant_components` (BOM)
- [ ] Ecto Schemas + Changesets for above
- [ ] Seed script: demo product + Size options (S,M,L,LL,3L,4L)
- **DoD**: `mix ecto.migrate` and `mix run priv/repo/seeds.exs` succeed.

### M2 — Inventory (DB + Services)
- [ ] Migration: `locations`, `inventory_levels`
- [ ] Migration: `component_stocks`
- [ ] Inventory service: reserve/release/ship for **preassembled**
- [ ] Inventory service: reserve/release/ship for **assemble_on_order** (BOM expansion)
- [ ] Row-level locking with `SELECT … FOR UPDATE`
- **DoD**: happy-path reservation works in both modes; unit tests pass.

### M3 — Admin (LiveView)
- [ ] `/admin/products` list + new/edit (title/slug/description/status/tags/SEO)
- [ ] Media DnD upload (local storage adapter)
- [ ] Options UI → **auto-generate size variants** (S..4L)
- [ ] Variant table: price, status, weight
- [ ] Inventory grid (location × SKU)
- **DoD**: Create product → generate variants → edit inventory end-to-end in Admin.

### M4 — Storefront & Checkout (MVP)
- [ ] Product list/detail
- [ ] Cart
- [ ] Checkout (bank transfer / COD)
- [ ] Shipping rates: flat / weight-based
- [ ] Order creation + emails (Swoosh)
- **DoD**: Place an order through UI; email rendered; manual fulfill possible.

### M5 — CSV & Events
- [ ] CSV Import/Export: products/variants/inventory
- [ ] Shipping CSV export from Orders
- [ ] PubSub events: `order.created`, `stock.changed`
- **DoD**: Round-trip real data via CSV; events emitted on order/stock changes.

### M6 — Tests & Hardening
- [ ] LiveView happy-path tests (Admin Product editor)
- [ ] Concurrency tests for reservation (same SKU race)
- [ ] Credo strict passes
- [ ] Dialyzer passes (PLT cached)
- [ ] Sobelow passes (no high/critical)
- **DoD**: CI fully green; race tests prove no oversell.

---

## 📋 Definition of Done (Global)
- Admin **no-code** flow: create product → auto-generate size variants → edit inventory → place order → export shipping CSV.
- Both inventory modes keep consistency (tests included).
- CI (format/credo/dialyzer/sobelow/test) green on PRs.
- README briefly explains run/seed/test.

---

## 🧪 Quality Targets
- Unit tests first for services (Catalog/Inventory).
- Coverage (statement): **≥ 70%** by end of M6 (stretch).
- Dialyzer: no warnings on CI.
- Sobelow: no High/Critical findings.

---

## 🛠️ Helpful Commands (Docker)
```bash
# Migrations
docker compose run --rm app mix ecto.gen.migration init_catalog_phase1
docker compose run --rm app mix ecto.create
docker compose run --rm app mix ecto.migrate

# Tests (with DB service running)
docker compose run --rm -e MIX_ENV=test app sh -lc \
  "mix do ecto.create --quiet, ecto.migrate --quiet, test --color"

# Lint & static analysis
docker compose run --rm app mix format --check-formatted
docker compose run --rm app mix credo --strict
docker compose run --rm app mix dialyzer --halt-exit-status
docker compose run --rm app mix sobelow --exit
