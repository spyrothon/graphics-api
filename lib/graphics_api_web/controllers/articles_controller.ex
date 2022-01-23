defmodule GraphicsAPIWeb.ArticlesController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Newsletters

  get "" do
    json(conn, Newsletters.list_articles())
  end

  get "/:id" do
    article_id = Map.get(conn.path_params, "id")

    if article_id != nil do
      json(conn, Newsletters.get_article(article_id))
    end
  end

  post "/" do
    newsletter_params = conn.body_params

    with {:ok, article} <- Newsletters.create_article(newsletter_params) do
      json(conn, article)
    else
      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  put "/:id" do
    article_id = conn.path_params["id"]
    newsletter_params = conn.body_params

    with article = %Newsletters.Article{} <- Newsletters.get_article(article_id),
         {:ok, article} <- Newsletters.update_article(article, newsletter_params) do
      json(conn, article)
    else
      article when is_nil(article) ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  delete "/:id" do
    article_id = conn.path_params["id"]

    with article = %Newsletters.Article{} <- Newsletters.get_article(article_id),
         {:ok, _newsletter} <- Newsletters.delete_article(article) do
      no_content(conn)
    else
      nil ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end
end
