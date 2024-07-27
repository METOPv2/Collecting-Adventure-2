local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Source.Classes.Signal)
local PlayerStatsController = {
	StatsChanged = Signal.new(),
}
local GetPlayerStats: RemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunctions").GetPlayerStats
local PlayerStatsChanged: RemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvents").PlayerStatsChanged

PlayerStatsChanged.OnClientEvent:Connect(function(key, value, oldValue)
	PlayerStatsController.Stats[key] = value
	PlayerStatsController.StatsChanged:Fire(key, value, oldValue)
end)

function PlayerStatsController.Init()
	local playerStats = GetPlayerStats:InvokeServer()
	PlayerStatsController.Stats = playerStats
	PlayerStatsController.StatsChanged:Connect(function(...)
		print(...)
	end)
end

return PlayerStatsController
