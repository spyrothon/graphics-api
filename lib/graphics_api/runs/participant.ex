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

  require Protocol
  Protocol.derive(Jason.Encoder, GraphicsAPI.Runs.Participant, only: @fields)
end
