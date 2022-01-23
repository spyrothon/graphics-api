defmodule GraphicsAPI.Repo.Migrations.CreateNewsletters do
  use Ecto.Migration

  def change do
    create table(:newsletters_newsletters) do
      add(:title, :string)
      add(:introduction, :string)
      add(:published, :boolean, default: false)

      timestamps()
    end

    create table(:newsletters_articles) do
      add(:title, :string)
      add(:author_name, :string)
      add(:published_at, :utc_datetime)
      add(:content, :string)

      timestamps()
    end

    create table(:newsletters_publications) do
      add(:newsletter_id, references(:newsletters_newsletters))
      add(:article_id, references(:newsletters_articles))
      add(:priority, :integer)
    end
  end
end
