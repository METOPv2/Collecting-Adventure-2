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
end

function PlayerStatsController.GetStats()
	if not PlayerStatsController.Stats then
		repeat
			task.wait()
		until PlayerStatsController.Stats
	end
	return PlayerStatsController.Stats
end

return PlayerStatsController
