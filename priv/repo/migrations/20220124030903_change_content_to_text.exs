defmodule GraphicsAPI.Repo.Migrations.ChangeContentToText do
  use Ecto.Migration

  def change do
    alter table(:newsletters_newsletters) do
      modify(:introduction, :text)
    end

    alter table(:newsletters_articles) do
      modify(:content, :text)
    end
  end
end
