defmodule Tell1storyWeb.PageLiveTest do
  use Tell1storyWeb.ConnCase
  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {ok: page_live, disconnected_html} = live(conn, "/")
  end
end
