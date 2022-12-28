defmodule Tell1story.Rooms.Room do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string
    field :description, :string
    field :invite_code, :string
    field :password, :string

    belongs_to :user, Tell1story.Users.User
    timestamps()
  end

  def changeset(room, attrs, opts \\ []) do
    room
    |> cast(attrs, [:name, :description, :invite_code, :user_id, :password])
    |> validate_required([:name, :description, :user_id])
    |> maybe_generate_invite_token(opts)
  end

  defp maybe_generate_invite_token(changeset, opts) do
    generate_invite? = Access.get(opts, :generate_invite?, false)

    room_is_new? =
      changeset
      |> get_field(:application)
      |> is_nil()

    if generate_invite? or room_is_new? do
      put_change(changeset, :invite_code, random_string(20))
    else
      changeset
    end
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
