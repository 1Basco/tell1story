defmodule Tell1storyWeb.Live.Auth do
  @moduledoc """
  Live view responsible for authentication within a live session
  """
  import Phoenix.LiveView
  alias Tell1story.Users

  def on_mount(:default, _params, session, socket) do
    # get user by the id in the session

    if is_nil(session["user_token"]) do
      {:cont, socket}
    else
      user = Users.get_user_by_session_token(session["user_token"])

      case user do
        user ->
          {:cont, assign(socket, current_user: user)}

        _error ->
          {:halt, redirect(socket, to: "/")}
      end
    end
  end
end
