# {:ok, pid} = Twitch.TokenManager.start_link(id: 1, persister: GraphicsAPI.TwitchTokenPersister)
# IO.puts(pid)

full_token = Twitch.TokenManager.get_full_token()
IO.inspect(full_token)

IO.inspect(Twitch.Authentication.get_valid_token())
