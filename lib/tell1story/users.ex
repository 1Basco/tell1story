defmodule Tell1story.Users do
  @moduledoc """
    Users Context
  """
  import Ecto.Query, warn: false

  alias Tell1story.Repo

  alias Tell1story.Users.User

  alias Ueberauth.Auth

  def find_or_create(%Auth{} = auth) do
    auth
    |> user_exists?()
    |> handle_user()
  end

  defp user_exists?(auth) do
    user = Repo.get_by(User, discord_id: auth.uid)

    case user do
      nil -> {:error, auth}
      user -> {:ok, user}
    end
  end

  defp handle_user({:error, auth}) do
    create_user(auth)
  end

  defp handle_user({:ok, user}) do
    safe_user = get_user_safe_by_id(user.id)
    {:ok, safe_user}
  end

  defp create_user(auth) do
    attrs =
      auth
      |> basic_info()

    case Repo.insert(%User{} |> Map.merge(attrs)) do
      {:ok, user} ->
        user

      {:error, _} ->
        nil
        # handle error here
    end
  end

  defp basic_info(auth) do
    %{
      discord_id: auth.uid,
      username: auth.info.nickname,
      discriminator: Map.get(auth, [:extra, :raw_info, :user, "discriminator"]),
      avatar: auth.info.image,
      email: auth.info.email,
      access_token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token
    }
  end

  def get_user_by_session_token(token) do
    user = Repo.get_by(User, token: token)

    case user do
      nil ->
        nil

      user ->
        %{
          id: user.id,
          username: user.username,
          avatar: user.avatar
        }
    end
  end

  def update_or_insert_token(user, token) do
    if user do
      full_user = Repo.get_by(User, id: user.id)
      changeset = User.changeset(full_user, %{token: token})
      Repo.update(changeset)
      get_user_safe_by_id(user.id)
    end
  end

  def get_user_safe_by_id(user_id) when is_nil(user_id), do: nil

  def get_user_safe_by_id(user_id) do
    user = Repo.get_by(User, id: user_id)

    case user do
      nil ->
        nil

      user ->
        %{
          id: user.id,
          username: user.username,
          avatar: user.avatar
        }
    end
  end
end
