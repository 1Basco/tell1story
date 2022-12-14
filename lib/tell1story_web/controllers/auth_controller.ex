defmodule Tell1storyWeb.AuthController do
  use Tell1storyWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Tell1story.Users
  alias Tell1storyWeb.Plug.Auth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Deslogado com sucesso")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
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
        |> Auth.put_current_user(user)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
