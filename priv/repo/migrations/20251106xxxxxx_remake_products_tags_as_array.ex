defmodule ShibasouShop.Repo.Migrations.RemakeProductsTagsAsArray do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE products DROP COLUMN IF EXISTS tags;")
    execute("ALTER TABLE products ADD COLUMN tags text[] DEFAULT ARRAY[]::text[];")
  end

  def down do
    execute("ALTER TABLE products DROP COLUMN IF EXISTS tags;")
    execute("ALTER TABLE products ADD COLUMN tags text;")
  end
end
