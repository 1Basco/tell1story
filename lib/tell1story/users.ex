defmodule Tell1story.Users do
  import Ecto.Query, warn: false

  alias Tell1story.Repo

  alias Tell1story.Users.User

  alias Ueberauth.Auth

  # def find_or_create(%{Auth} = ) do
  #   user = Repo.get(User, attrs)

  #   case user do
  #     nil -> Repo.insert(%User{} |> Map.merge(attrs))
  #     user -> user
  #   end
  # end

  # def find_or_create(%Auth{provider: :identity} = auth) do
  #   case validate_pass(auth.credentials) do
  #     :ok ->
  #       {:ok, basic_info(auth)}

  #     {:error, reason} ->
  #       {:error, reason}
  #   end
  # end

  def find_or_create(%Auth{} = auth) do
    auth
    |> user_exists?()
    |> handle_user()

    # |> set_user
  end

  defp user_exists?(auth) do
    user = Repo.get(User, auth.uid)

    case user do
      nil -> {:error, auth}
      user -> {:ok, user}
    end
  end

  defp handle_user({:error, auth}) do
    create_user(auth)
  end

  defp handle_user({:ok, user}) do
    # TODO: update credentials
  end

  defp create_user(auth) do
    attrs =
      auth
      |> basic_info()

    Repo.insert(%User{} |> Map.merge(attrs))
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
end
