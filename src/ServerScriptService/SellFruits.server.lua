local PlayerStatsService = require(game.ServerStorage.Source.Services.PlayerStats.PlayerStatsService)
local sellPrompt: ProximityPrompt = workspace.SellMan.HumanoidRootPart.Sell

sellPrompt.Triggered:Connect(function(playerWhoTriggered)
	local stats = PlayerStatsService.GetPlayerStatsFromService(playerWhoTriggered)
	for _, fruit in ipairs(stats.Inventory) do
		stats.Money += fruit.Value
	end
	stats:set("Inventory", {})
	stats:set("Money", stats.Money)
end)
