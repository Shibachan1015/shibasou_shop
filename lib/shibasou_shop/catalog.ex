defmodule ShibasouShop.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias ShibasouShop.Repo

  alias ShibasouShop.Catalog.Ten

  @doc """
  Returns the list of tens.

  ## Examples

      iex> list_tens()
      [%Ten{}, ...]

  """
  def list_tens do
    Repo.all(Ten)
  end

  @doc """
  Gets a single ten.

  Raises `Ecto.NoResultsError` if the Ten does not exist.

  ## Examples

      iex> get_ten!(123)
      %Ten{}

      iex> get_ten!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ten!(id), do: Repo.get!(Ten, id)

  @doc """
  Creates a ten.

  ## Examples

      iex> create_ten(%{field: value})
      {:ok, %Ten{}}

      iex> create_ten(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ten(attrs) do
    %Ten{}
    |> Ten.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ten.

  ## Examples

      iex> update_ten(ten, %{field: new_value})
      {:ok, %Ten{}}

      iex> update_ten(ten, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ten(%Ten{} = ten, attrs) do
    ten
    |> Ten.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ten.

  ## Examples

      iex> delete_ten(ten)
      {:ok, %Ten{}}

      iex> delete_ten(ten)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ten(%Ten{} = ten) do
    Repo.delete(ten)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ten changes.

  ## Examples

      iex> change_ten(ten)
      %Ecto.Changeset{data: %Ten{}}

  """
  def change_ten(%Ten{} = ten, attrs \\ %{}) do
    Ten.changeset(ten, attrs)
  end

  alias ShibasouShop.Catalog.Outsole

  @doc """
  Returns the list of outsoles.

  ## Examples

      iex> list_outsoles()
      [%Outsole{}, ...]

  """
  def list_outsoles do
    Repo.all(Outsole)
  end

  @doc """
  Gets a single outsole.

  Raises `Ecto.NoResultsError` if the Outsole does not exist.

  ## Examples

      iex> get_outsole!(123)
      %Outsole{}

      iex> get_outsole!(456)
      ** (Ecto.NoResultsError)

  """
  def get_outsole!(id), do: Repo.get!(Outsole, id)

  @doc """
  Creates a outsole.

  ## Examples

      iex> create_outsole(%{field: value})
      {:ok, %Outsole{}}

      iex> create_outsole(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_outsole(attrs) do
    %Outsole{}
    |> Outsole.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a outsole.

  ## Examples

      iex> update_outsole(outsole, %{field: new_value})
      {:ok, %Outsole{}}

      iex> update_outsole(outsole, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_outsole(%Outsole{} = outsole, attrs) do
    outsole
    |> Outsole.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a outsole.

  ## Examples

      iex> delete_outsole(outsole)
      {:ok, %Outsole{}}

      iex> delete_outsole(outsole)
      {:error, %Ecto.Changeset{}}

  """
  def delete_outsole(%Outsole{} = outsole) do
    Repo.delete(outsole)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking outsole changes.

  ## Examples

      iex> change_outsole(outsole)
      %Ecto.Changeset{data: %Outsole{}}

  """
  def change_outsole(%Outsole{} = outsole, attrs \\ %{}) do
    Outsole.changeset(outsole, attrs)
  end

  alias ShibasouShop.Catalog.Hanao

  @doc """
  Returns the list of hanaos.

  ## Examples

      iex> list_hanaos()
      [%Hanao{}, ...]

  """
  def list_hanaos do
    Repo.all(Hanao)
  end

  @doc """
  Gets a single hanao.

  Raises `Ecto.NoResultsError` if the Hanao does not exist.

  ## Examples

      iex> get_hanao!(123)
      %Hanao{}

      iex> get_hanao!(456)
      ** (Ecto.NoResultsError)

  """
  def get_hanao!(id), do: Repo.get!(Hanao, id)

  @doc """
  Creates a hanao.

  ## Examples

      iex> create_hanao(%{field: value})
      {:ok, %Hanao{}}

      iex> create_hanao(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hanao(attrs) do
    %Hanao{}
    |> Hanao.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hanao.

  ## Examples

      iex> update_hanao(hanao, %{field: new_value})
      {:ok, %Hanao{}}

      iex> update_hanao(hanao, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_hanao(%Hanao{} = hanao, attrs) do
    hanao
    |> Hanao.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a hanao.

  ## Examples

      iex> delete_hanao(hanao)
      {:ok, %Hanao{}}

      iex> delete_hanao(hanao)
      {:error, %Ecto.Changeset{}}

  """
  def delete_hanao(%Hanao{} = hanao) do
    Repo.delete(hanao)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking hanao changes.

  ## Examples

      iex> change_hanao(hanao)
      %Ecto.Changeset{data: %Hanao{}}

  """
  def change_hanao(%Hanao{} = hanao, attrs \\ %{}) do
    Hanao.changeset(hanao, attrs)
  end
end
