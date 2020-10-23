defmodule GraphicsAPI.Runs.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :user_id,
    :display_name,
    :twitch_name,
    :nickname
  ]

  embedded_schema do
    field(:user_id, :integer)
    # These fields are proxied from the User records to enable embedded uses. The values
    # are what was provided at creation time and may not reflect the current state of the
    # record.
    #
    # Consumers should only use these values as fallbacks, and request full User records
    # if the data is intended to be used in any meaningful way.
    field(:display_name, :string)
    field(:twitch_name, :string)
    # These fields are additional, overriding data to apply on top of the User record
    field(:nickname, :string)
  end

  def changeset(participant, params \\ %{}) do
    participant
    |> cast(params, @fields)
    |> validate_required([:user_id])
  end

  def fields, do: @fields
end

defimpl Jason.Encoder, for: [GraphicsAPI.Runs.Participant] do
  def encode(%{__struct__: _} = struct, options) do
    struct
    |> Map.from_struct()
    |> Map.take(GraphicsAPI.Runs.Participant.fields())
    |> stringify_id()
    |> Jason.Encode.map(options)
  end

  defp stringify_id(data) do
    data
    |> Map.put(:user_id, Integer.to_string(data.user_id))
  end
end
