defmodule Tell1storyWeb.AuthController do
  use Tell1storyWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Tell1story.Users

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Users.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  # alias Tell1story.{Repo, User}

  # def request(conn, _params) do
  #   redirect(
  #     conn,
  #     external: Ueberauth.Strategy.Discord.authorize_url()
  #   )
  # end

  # def callback(conn, %{"code" => _code, "state" => _state}) do
  #   case Ueberauth.Strategy.Discord.callback(%{ueberauth_discord: %{callback_params: conn.params}}) do
  #     {:ok,
  #      %{
  #        "info" => %{
  #          "id" => discord_id,
  #          "username" => username,
  #          "discriminator" => discriminator,
  #          "avatar" => avatar,
  #          "email" => email
  #        },
  #        "credentials" => %{
  #          "token" => access_token,
  #          "refresh_token" => refresh_token,
  #          "expires" => expires_at
  #        }
  #      }} ->
  #       # Find or create the user based on the Discord ID
  #       user =
  #         Repo.get_by(User, discord_id: discord_id) ||
  #           User.changeset(%User{}, %{
  #             discord_id: discord_id,
  #             username: username,
  #             discriminator: discriminator,
  #             avatar: avatar,
  #             email: email,
  #             access_token: access_token,
  #             refresh_token: refresh_token
  #           })
  #           |> Repo.insert()

  #       # Store the user in the session
  #       conn
  #       |> put_session(:current_user, user)
  #       |> redirect(to: "/")
  #   end
  # end
end
