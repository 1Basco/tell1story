defmodule Tell1story.Users.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :discord_id, :string
    field :username, :string
    field :discriminator, :integer
    field :avatar, :string
    field :email, :string
    field :access_token, :string
    field :refresh_token, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :discord_id,
      :username,
      :discriminator,
      :avatar,
      :email,
      :access_token,
      :refresh_token,
      :token
    ])
    |> validate_required([:discord_id, :username])
  end
end
