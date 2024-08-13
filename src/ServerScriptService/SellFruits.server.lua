local sellAllFruits: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SellAllFruits
local sellFruit: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SellFruit
local FruitService = require(game.ServerStorage.Source.Services.FruitService)
local FruitStats = require(game.ReplicatedStorage.Source.Stats.Fruits)

sellAllFruits.OnServerEvent:Connect(function(player)
	FruitService.SellFruits(player)
end)
sellFruit.OnServerEvent:Connect(function(player, uniqueId: string)
	for _, fruit in ipairs(player.PlayerStats.Inventory:GetChildren()) do
		local fruitStats = FruitStats[fruit.Name]
		if fruit.UniqueId.Value == uniqueId then
			player.PlayerStats.Money.Value += (fruit.Weight.Value / 1000) * fruitStats.Value
			fruit:Destroy()
		end
	end
end)
