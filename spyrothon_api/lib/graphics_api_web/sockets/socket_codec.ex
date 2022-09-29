defmodule GraphicsAPIWeb.SyncSocketCodec do
  @behaviour Riverside.Codec

  @impl Riverside.Codec
  def frame_type do
    :text
  end

  @impl Riverside.Codec
  def encode(msg) do
    case Jason.encode(msg) do
      {:ok, value} ->
        {:ok, value}

      {:error, _exception} ->
        {:error, :invalid_message}
    end
  end

  @impl Riverside.Codec
  def decode(data) do
    case Jason.decode(data) do
      {:ok, value} ->
        {:ok, value}

      {:error, _exception} ->
        {:error, :invalid_message}
    end
  end
end
