defmodule GraphicsAPIWeb.NewslettersController do
  use GraphicsAPIWeb.APIController

  alias GraphicsAPI.Newsletters

  get "" do
    json(conn, Newsletters.list_newsletters())
  end

  get "/:id" do
    newsletter_id = Map.get(conn.path_params, "id")

    if newsletter_id != nil do
      json(conn, Newsletters.get_newsletter(newsletter_id))
    end
  end

  post "/" do
    newsletter_params = conn.body_params

    with {:ok, newsletter} <- Newsletters.create_newsletter(newsletter_params) do
      json(conn, Newsletters.get_newsletter(newsletter.id))
    else
      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  put "/:id" do
    newsletter_id = conn.path_params["id"]
    newsletter_params = conn.body_params

    with newsletter = %Newsletters.Newsletter{} <- Newsletters.get_newsletter(newsletter_id),
         {:ok, newsletter} <- Newsletters.update_newsletter(newsletter, newsletter_params) do
      json(conn, Newsletters.get_newsletter(newsletter.id))
    else
      newsletter when is_nil(newsletter) ->
        conn |> not_found()

      {:error, changeset} ->
        conn
        |> changeset_error(changeset)
    end
  end

  delete "/:id" do
    newsletter_id = conn.path_params["id"]

    with newsletter = %Newsletters.Newsletter{} <- Newsletters.get_newsletter(newsletter_id),
         {:ok, _newsletter} <- Newsletters.delete_newsletter(newsletter) do
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
