defmodule GraphicsAPI.Newsletters do
  import Ecto.Query, warn: false
  alias GraphicsAPI.Repo

  alias GraphicsAPI.Newsletters.{Newsletter, Article}

  ###
  # Newsletters
  ###

  def list_newsletters() do
    Repo.all(Newsletter)
    |> Repo.preload([:publications, :articles])
  end

  def get_newsletter(newsletter_id) do
    Repo.get(Newsletter, newsletter_id)
    |> Repo.preload([:publications, :articles])
  end

  def create_newsletter(params) do
    %Newsletter{}
    |> Newsletter.changeset(params)
    |> Repo.insert()
  end

  def update_newsletter(newsletter = %Newsletter{}, params) do
    newsletter
    |> Newsletter.changeset(params)
    |> Repo.update()
  end

  def delete_newsletter(newsletter = %Newsletter{}) do
    newsletter
    |> Repo.delete()
  end

  ###
  # Articles
  ###

  def list_articles() do
    Repo.all(Article)
  end

  def get_article(article_id) do
    Repo.get(Article, article_id)
  end

  def create_article(params) do
    %Article{}
    |> Article.changeset(params)
    |> Repo.insert()
  end

  def update_article(article = %Article{}, params) do
    article
    |> Article.changeset(params)
    |> Repo.update()
  end

  def delete_article(article = %Article{}) do
    article
    |> Repo.delete()
  end
end
