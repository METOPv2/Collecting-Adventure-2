local sellAllFruits: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SellAllFruits
local sellFruit: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SellFruit
local FruitService = require(game.ServerStorage.Source.Services.FruitService)
local FruitStats = require(game.ReplicatedStorage.Source.Stats.Fruits)
local FruitsSold: RemoteEvent = game.ReplicatedStorage.RemoteEvents.FruitsSold

sellAllFruits.OnServerEvent:Connect(function(player)
	local sold = {
		normal = false,
		golden = false,
		diamond = false,
	}
	for _, fruit in ipairs(player.PlayerStats.Inventory:GetChildren()) do
		if fruit.IsDiamond.Value == true then
			sold.diamond = true
		end

		if fruit.IsGolden.Value == true then
			sold.golden = true
		end

		if fruit.IsDiamond.Value == false and fruit.IsGolden.Value == false then
			sold.normal = true
		end
	end
	FruitService.SellFruits(player)
	FruitsSold:FireAllClients(player.UserId, sold)
end)

sellFruit.OnServerEvent:Connect(function(player, uniqueId: string)
	local sold = {
		normal = false,
		golden = false,
		diamond = false,
	}
	for _, fruit in ipairs(player.PlayerStats.Inventory:GetChildren()) do
		local fruitStats = FruitStats[fruit.Name]
		if fruit.UniqueId.Value == uniqueId then
			if fruit.IsDiamond.Value == true then
				sold.diamond = true
			end

			if fruit.IsGolden.Value == true then
				sold.golden = true
			end

			if fruit.IsDiamond.Value == false and fruit.IsGolden.Value == false then
				sold.normal = true
			end
			player.PlayerStats.Money.Value += (fruit.Weight.Value / 1000) * fruitStats.Value
			fruit:Destroy()
		end
	end
	FruitsSold:FireAllClients(player.UserId, sold)
end)
