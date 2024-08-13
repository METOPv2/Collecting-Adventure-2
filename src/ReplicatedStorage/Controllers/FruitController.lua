local BackpackStats = require(game.ReplicatedStorage.Source.Stats.Backpacks)
local FruitController = {}

function FruitController.GetTakenCapacity(): number
	local takenCapacity = 0
	for _, fruit in ipairs(game.Players.LocalPlayer.PlayerStats.Inventory:GetChildren()) do
		takenCapacity += fruit.Weight.Value
	end
	return takenCapacity
end

function FruitController.GetTakenCapacityInKG(): number
	local takenCapacity = 0
	for _, fruit in ipairs(game.Players.LocalPlayer.PlayerStats.Inventory:GetChildren()) do
		takenCapacity += fruit.Weight.Value
	end
	return takenCapacity / 1000
end

function FruitController.GetCapacity(): number
	return BackpackStats[game.Players.LocalPlayer.PlayerStats.EquippedBackpack.Value].Capacity
end

return FruitController
