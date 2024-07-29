local PlayerStatsController = require(game.ReplicatedStorage.Source.Controllers.PlayerStatsController)
local PlayerStatsChanged: RemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvents").PlayerStatsChanged
PlayerStatsChanged.OnClientEvent:Connect(function(key, value, oldValue)
	PlayerStatsController.Stats[key] = value
	PlayerStatsController.StatsChanged:Fire(key, value, oldValue)
end)
