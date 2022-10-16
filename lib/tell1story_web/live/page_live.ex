defmodule Tell1storyWeb.PageLive do
  use Tell1storyWeb, :live_view

  def mount(_params, _section, socket) do
    {:ok,
      socket
      |> assign(page_title: "MEMES")}
  end
end
