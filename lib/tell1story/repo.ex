defmodule Tell1story.Repo do
  use Ecto.Repo,
    otp_app: :tell1story,
    adapter: Ecto.Adapters.Postgres
end
