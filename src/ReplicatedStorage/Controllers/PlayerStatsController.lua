local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Source.Classes.Signal)
local PlayerStatsController = {
	StatsChanged = Signal.new(),
}
local GetPlayerStats: RemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunctions").GetPlayerStats

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
end

return PlayerStatsController
