defmodule Tell1storyWeb.Plug.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias Tell1storyWeb.Router.Helpers, as: Routes
  alias Tell1story.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    user =
      cond do
        assigned = conn.assigns[:current_user] -> assigned
        true -> Users.get_user_safe_by_id(user_id)
      end

    put_current_user(conn, user)
  end

  def logged_in_user(conn = %{assigns: %{current_user: %{}}}, _), do: conn

  # not_logged
  def logged_in_user(conn = %{private: %{phoenix_format: "json"}}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> halt()
    |> json(%{error: "unauthorized"})
  end

  def logged_in_user(conn, _opts) do
    conn
    |> put_flash(:error, "Você precisa estar logado para acessar essa página")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

  def put_current_user(conn, user) do
    token = user && Tell1storyWeb.Token.sign(%{id: user.id})
    updated_user = Users.update_or_insert_token(user, token)

    conn
    |> assign(:current_user, updated_user)
    |> assign(:user_token, token)
    |> put_session(:user_id, updated_user && updated_user.id)
    |> put_session(:user_token, updated_user && token)
    |> configure_session(renew: true)
    |> put_req_header("authorization", "Bearer #{token}")
  end

  def drop_current_user(conn) do
    conn
    |> delete_req_header("authorization")
    |> configure_session(drop: true)
  end
end
