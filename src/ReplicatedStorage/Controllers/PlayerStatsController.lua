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
	local stats = PlayerStatsController.GetStatsFromServer()
	PlayerStatsController.SetStatsToController(stats)
end

function PlayerStatsController.GetStats()
	if not PlayerStatsController.Stats then
		PlayerStatsController.StatsChanged:Wait()
	end
	return PlayerStatsController.Stats
end

function PlayerStatsController.GetStatsFromServer()
	return GetPlayerStats:InvokeServer()
end

function PlayerStatsController.SetStatsToController(stats: {})
	PlayerStatsController.Stats = stats
	PlayerStatsController.StatsChanged:Fire()
end

return PlayerStatsController
