defmodule Tell1storyWeb.PageController do
  use Tell1storyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
