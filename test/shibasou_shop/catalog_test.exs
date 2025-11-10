defmodule ShibasouShop.CatalogTest do
  use ShibasouShop.DataCase
  @moduletag :legacy

  alias ShibasouShop.Catalog

  describe "tens" do
    alias ShibasouShop.Catalog.Ten

    import ShibasouShop.CatalogFixtures

    @invalid_attrs %{
      code: nil,
      enabled: nil,
      name: nil,
      price_delta_cents: nil,
      stock_qty: nil,
      allocated_qty: nil,
      backordered_qty: nil,
      image_layer_url: nil
    }

    test "list_tens/0 returns all tens" do
      ten = ten_fixture()
      assert Catalog.list_tens() == [ten]
    end

    test "get_ten!/1 returns the ten with given id" do
      ten = ten_fixture()
      assert Catalog.get_ten!(ten.id) == ten
    end

    test "create_ten/1 with valid data creates a ten" do
      valid_attrs = %{
        code: "some code",
        enabled: true,
        name: "some name",
        price_delta_cents: 42,
        stock_qty: 42,
        allocated_qty: 42,
        backordered_qty: 42,
        image_layer_url: "some image_layer_url"
      }

      assert {:ok, %Ten{} = ten} = Catalog.create_ten(valid_attrs)
      assert ten.code == "some code"
      assert ten.enabled == true
      assert ten.name == "some name"
      assert ten.price_delta_cents == 42
      assert ten.stock_qty == 42
      assert ten.allocated_qty == 42
      assert ten.backordered_qty == 42
      assert ten.image_layer_url == "some image_layer_url"
    end

    test "create_ten/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_ten(@invalid_attrs)
    end

    test "update_ten/2 with valid data updates the ten" do
      ten = ten_fixture()

      update_attrs = %{
        code: "some updated code",
        enabled: false,
        name: "some updated name",
        price_delta_cents: 43,
        stock_qty: 43,
        allocated_qty: 43,
        backordered_qty: 43,
        image_layer_url: "some updated image_layer_url"
      }

      assert {:ok, %Ten{} = ten} = Catalog.update_ten(ten, update_attrs)
      assert ten.code == "some updated code"
      assert ten.enabled == false
      assert ten.name == "some updated name"
      assert ten.price_delta_cents == 43
      assert ten.stock_qty == 43
      assert ten.allocated_qty == 43
      assert ten.backordered_qty == 43
      assert ten.image_layer_url == "some updated image_layer_url"
    end

    test "update_ten/2 with invalid data returns error changeset" do
      ten = ten_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_ten(ten, @invalid_attrs)
      assert ten == Catalog.get_ten!(ten.id)
    end

    test "delete_ten/1 deletes the ten" do
      ten = ten_fixture()
      assert {:ok, %Ten{}} = Catalog.delete_ten(ten)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_ten!(ten.id) end
    end

    test "change_ten/1 returns a ten changeset" do
      ten = ten_fixture()
      assert %Ecto.Changeset{} = Catalog.change_ten(ten)
    end
  end

  describe "outsoles" do
    alias ShibasouShop.Catalog.Outsole

    import ShibasouShop.CatalogFixtures

    @invalid_attrs %{
      code: nil,
      enabled: nil,
      name: nil,
      price_delta_cents: nil,
      stock_qty: nil,
      allocated_qty: nil,
      backordered_qty: nil,
      image_layer_url: nil
    }

    test "list_outsoles/0 returns all outsoles" do
      outsole = outsole_fixture()
      assert Catalog.list_outsoles() == [outsole]
    end

    test "get_outsole!/1 returns the outsole with given id" do
      outsole = outsole_fixture()
      assert Catalog.get_outsole!(outsole.id) == outsole
    end

    test "create_outsole/1 with valid data creates a outsole" do
      valid_attrs = %{
        code: "some code",
        enabled: true,
        name: "some name",
        price_delta_cents: 42,
        stock_qty: 42,
        allocated_qty: 42,
        backordered_qty: 42,
        image_layer_url: "some image_layer_url"
      }

      assert {:ok, %Outsole{} = outsole} = Catalog.create_outsole(valid_attrs)
      assert outsole.code == "some code"
      assert outsole.enabled == true
      assert outsole.name == "some name"
      assert outsole.price_delta_cents == 42
      assert outsole.stock_qty == 42
      assert outsole.allocated_qty == 42
      assert outsole.backordered_qty == 42
      assert outsole.image_layer_url == "some image_layer_url"
    end

    test "create_outsole/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_outsole(@invalid_attrs)
    end

    test "update_outsole/2 with valid data updates the outsole" do
      outsole = outsole_fixture()

      update_attrs = %{
        code: "some updated code",
        enabled: false,
        name: "some updated name",
        price_delta_cents: 43,
        stock_qty: 43,
        allocated_qty: 43,
        backordered_qty: 43,
        image_layer_url: "some updated image_layer_url"
      }

      assert {:ok, %Outsole{} = outsole} = Catalog.update_outsole(outsole, update_attrs)
      assert outsole.code == "some updated code"
      assert outsole.enabled == false
      assert outsole.name == "some updated name"
      assert outsole.price_delta_cents == 43
      assert outsole.stock_qty == 43
      assert outsole.allocated_qty == 43
      assert outsole.backordered_qty == 43
      assert outsole.image_layer_url == "some updated image_layer_url"
    end

    test "update_outsole/2 with invalid data returns error changeset" do
      outsole = outsole_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_outsole(outsole, @invalid_attrs)
      assert outsole == Catalog.get_outsole!(outsole.id)
    end

    test "delete_outsole/1 deletes the outsole" do
      outsole = outsole_fixture()
      assert {:ok, %Outsole{}} = Catalog.delete_outsole(outsole)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_outsole!(outsole.id) end
    end

    test "change_outsole/1 returns a outsole changeset" do
      outsole = outsole_fixture()
      assert %Ecto.Changeset{} = Catalog.change_outsole(outsole)
    end
  end

  describe "hanaos" do
    alias ShibasouShop.Catalog.Hanao

    import ShibasouShop.CatalogFixtures

    @invalid_attrs %{
      code: nil,
      enabled: nil,
      name: nil,
      price_delta_cents: nil,
      stock_qty: nil,
      allocated_qty: nil,
      backordered_qty: nil,
      image_layer_url: nil
    }

    test "list_hanaos/0 returns all hanaos" do
      hanao = hanao_fixture()
      assert Catalog.list_hanaos() == [hanao]
    end

    test "get_hanao!/1 returns the hanao with given id" do
      hanao = hanao_fixture()
      assert Catalog.get_hanao!(hanao.id) == hanao
    end

    test "create_hanao/1 with valid data creates a hanao" do
      valid_attrs = %{
        code: "some code",
        enabled: true,
        name: "some name",
        price_delta_cents: 42,
        stock_qty: 42,
        allocated_qty: 42,
        backordered_qty: 42,
        image_layer_url: "some image_layer_url"
      }

      assert {:ok, %Hanao{} = hanao} = Catalog.create_hanao(valid_attrs)
      assert hanao.code == "some code"
      assert hanao.enabled == true
      assert hanao.name == "some name"
      assert hanao.price_delta_cents == 42
      assert hanao.stock_qty == 42
      assert hanao.allocated_qty == 42
      assert hanao.backordered_qty == 42
      assert hanao.image_layer_url == "some image_layer_url"
    end

    test "create_hanao/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_hanao(@invalid_attrs)
    end

    test "update_hanao/2 with valid data updates the hanao" do
      hanao = hanao_fixture()

      update_attrs = %{
        code: "some updated code",
        enabled: false,
        name: "some updated name",
        price_delta_cents: 43,
        stock_qty: 43,
        allocated_qty: 43,
        backordered_qty: 43,
        image_layer_url: "some updated image_layer_url"
      }

      assert {:ok, %Hanao{} = hanao} = Catalog.update_hanao(hanao, update_attrs)
      assert hanao.code == "some updated code"
      assert hanao.enabled == false
      assert hanao.name == "some updated name"
      assert hanao.price_delta_cents == 43
      assert hanao.stock_qty == 43
      assert hanao.allocated_qty == 43
      assert hanao.backordered_qty == 43
      assert hanao.image_layer_url == "some updated image_layer_url"
    end

    test "update_hanao/2 with invalid data returns error changeset" do
      hanao = hanao_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_hanao(hanao, @invalid_attrs)
      assert hanao == Catalog.get_hanao!(hanao.id)
    end

    test "delete_hanao/1 deletes the hanao" do
      hanao = hanao_fixture()
      assert {:ok, %Hanao{}} = Catalog.delete_hanao(hanao)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_hanao!(hanao.id) end
    end

    test "change_hanao/1 returns a hanao changeset" do
      hanao = hanao_fixture()
      assert %Ecto.Changeset{} = Catalog.change_hanao(hanao)
    end
  end
end
