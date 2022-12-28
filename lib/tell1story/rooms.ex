defmodule Tell1story.Rooms do
  @moduledoc """
    Rooms Context
  """
  import Ecto.Query, warn: false

  alias Tell1story.Repo

  alias Tell1story.Rooms.Room

  def get_public_rooms() do
    Repo.all(from r in Room, where: is_nil(r.password))
  end

  def get_user_rooms(user_id) when is_integer(user_id) do
    Repo.all(from r in Room, where: r.user_id == ^user_id)
  end

  def get_room!(id) do
    Repo.get!(Room, id)
  end

  def create_room(attrs) when is_map(attrs) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end
end
