defmodule GraphicsAPI.Repo.Migrations.AddPublishedAtToNewsletter do
  use Ecto.Migration

  def change do
    alter table(:newsletters_newsletters) do
      add(:published_at, :utc_datetime)
    end
  end
end
