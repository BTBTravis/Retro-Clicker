defmodule ClickGame.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ClickGame.Repo

  alias ClickGame.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
    |> Repo.preload(:game)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:game)
  end


  @doc """
  Gets a single user from there api key
  """
  def get_user_by_api_key(key) do
    Repo.get_by(User, apikey: key)
    |> Repo.preload(:game)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(
      attrs
      |> put_pass_hash
      |> put_apikey
    )
    |> Ecto.Changeset.cast_assoc(:game, with: &ClickGame.Games.Game.changeset/2)
    |> Repo.insert()
  end

  defp put_apikey(m) do
    apikey = :base64.encode(:crypto.strong_rand_bytes(42))
    case m do
      %{} -> Map.put(m, "apikey", apikey)
      _ -> m
    end
  end

  defp put_pass_hash(m) do
    case m do
      %{"pw" => pw} ->
        Map.put(m, "password_hash", simple_hash(pw))
      _ -> m
    end
  end

  defp simple_hash(pw) do
    Bcrypt.add_hash(pw).password_hash
  end


  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
