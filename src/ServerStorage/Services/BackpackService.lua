local BackpackService = {}
local NotificationsService = require(game.ServerStorage.Source.Services.NotiifcationsService)
local BackpacksStats = require(game.ReplicatedStorage.Source.Stats.Backpacks)

function BackpackService.Init()
	local backpackModels = workspace.BackpackShop.Backpacks

	for _, backpack in ipairs(backpackModels:GetChildren()) do
		local backpackStats = BackpacksStats[backpack.Name]
		local prompt: ProximityPrompt = backpack.PrimaryPart.ProximityPrompt
		prompt.RequiresLineOfSight = false
		prompt.ActionText = "Purchase"
		prompt.ObjectText = string.format("%s [Price: $%d]", backpackStats.Name, backpackStats.Price)
		prompt.Triggered:Connect(function(player)
			BackpackService.BuyBackpack(player, backpack.Name)
		end)
	end
end

function BackpackService.BuyBackpack(player: Player, backpackName: string)
	if BackpackService.HasBackpack(player, backpackName) then
		if BackpacksStats[backpackName].Capacity >= #player.PlayerStats.Inventory:GetChildren() then
			local equippedBackapack = player.PlayerStats.EquippedBackpack
			equippedBackapack.Value = backpackName
		else
			NotificationsService.Notify(player, "Can't equip", "Not enough space in backpack.", 5)
		end
	else
		local backpackStats = BackpacksStats[backpackName]
		local money = player.PlayerStats.Money
		local equippedBackapack = player.PlayerStats.EquippedBackpack
		if money.Value >= backpackStats.Price then
			local backpack = Instance.new("StringValue")
			backpack.Value = backpackName
			backpack.Parent = player.PlayerStats.Backpacks
			equippedBackapack.Value = backpackName
			money.Value -= backpackStats.Price
			NotificationsService.Notify(
				player,
				"Successfully purchased",
				"Congratulations on purchasing a new backpack!.",
				5
			)
		else
			NotificationsService.Notify(player, "Can't purchase", "Because you don't have enough money.", 5)
		end
	end
end

function BackpackService.HasBackpack(player: Player, backpackName: string): boolean
	local hasBackpack = false
	for _, backpack in ipairs(player.PlayerStats.Backpacks:GetChildren()) do
		if backpack.Value == backpackName then
			hasBackpack = true
			break
		end
	end
	return hasBackpack
end

return BackpackService
