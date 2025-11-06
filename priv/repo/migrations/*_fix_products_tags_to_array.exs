defmodule ShibasouShop.Repo.Migrations.FixProductsTagsToArray do
  use Ecto.Migration

  def up do
    execute("""
    ALTER TABLE products
    ALTER COLUMN tags TYPE text[]
    USING CASE
      WHEN tags IS NULL THEN ARRAY[]::text[]
      WHEN pg_typeof(tags)::text = 'text' THEN ARRAY[tags]::text[]
      ELSE tags
    END;
    """)

    execute("""
    ALTER TABLE products
    ALTER COLUMN tags SET DEFAULT ARRAY[]::text[];
    """)
  end

  def down do
    execute("""
    ALTER TABLE products
    ALTER COLUMN tags TYPE text
    USING CASE
      WHEN tags IS NULL THEN NULL
      ELSE array_to_string(tags, ',')
    END;
    """)

    execute("""
    ALTER TABLE products
    ALTER COLUMN tags DROP DEFAULT;
    """)
  end
end
