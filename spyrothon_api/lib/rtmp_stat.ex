defmodule RTMPStat do
  use Tesla

  def client(rtmp_host) do
    middleware = [
      {Tesla.Middleware.BaseUrl, rtmp_host}
    ]

    Tesla.client(middleware)
  end

  @spec get_stat(rtmp_host: String.t()) ::
          {:ok, String.t()}
          | {:error, any()}
  def get_stat(rtmp_host: rtmp_host) do
    response =
      client(rtmp_host)
      |> get("/stat")

    case response do
      {:ok, response} ->
        {:ok, response.body}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
