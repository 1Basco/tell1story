defmodule Tell1story.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :discord_id, :string
      add :username, :string
      add :discriminator, :integer
      add :avatar, :string
      add :email, :string
      add :access_token, :string
      add :refresh_token, :string

      timestamps()
    end
  end
end
