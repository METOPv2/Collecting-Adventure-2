game.ReplicatedStorage.RemoteEvents.ChangeSetting.OnServerEvent:Connect(
	function(player: Player, type: string, name: string, value: string)
		if type == "Binds" then
			player.PlayerStats.Settings.Binds:FindFirstChild(name).Value = value
		end
	end
)
