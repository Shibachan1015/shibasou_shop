alias ShibasouShop.Repo
alias ShibasouShop.Catalog.{Product, Option, OptionValue, Variant, Generator}

p = Repo.get_by(Product, slug: "zori") || Repo.insert!(%Product{title: "Zori", slug: "zori", status: "draft"})
opt = Repo.get_by(Option, product_id: p.id, name: "Size") || Repo.insert!(%Option{product_id: p.id, name: "Size"})
for v <- ~w[S M L LL 3L 4L], do: Repo.get_by(OptionValue, option_id: opt.id, value: v) || Repo.insert!(%OptionValue{option_id: opt.id, value: v})

IO.inspect(Generator.generate_size_variants(p.id), label: "generated")
