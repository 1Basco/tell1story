defmodule Tell1storyWeb.RoomsLive.Index do
  use Tell1storyWeb, :live_view
  alias Tell1story.Room

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
