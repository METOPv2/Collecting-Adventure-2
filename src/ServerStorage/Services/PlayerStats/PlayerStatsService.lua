local ServerStorage = game:GetService("ServerStorage")
local PlayerStatsService = {
	PlayerStatsDatabase = {},
}
local PlayerStatsTemplate = require(script.Parent.PlayerStatsTemplate)
local ObjectAndTableConverterService = require(ServerStorage.Source.Services.ObjectAndTableConverterService)
local DataStoreService = game:GetService("DataStoreService")
local PlayerStatsStore = DataStoreService:GetDataStore("PlayerStats")

function PlayerStatsService.Init()
	for _, player: Player in ipairs(game.Players:GetPlayers()) do
		PlayerStatsService.InitPlayerStats(player)
	end

	game.Players.PlayerAdded:Connect(PlayerStatsService.InitPlayerStats)
	game.Players.PlayerRemoving:Connect(PlayerStatsService.DeinitPlayerStats)

	game:BindToClose(function()
		while next(PlayerStatsService.PlayerStatsDatabase) do
			task.wait(1)
		end
	end)
end

function PlayerStatsService.InitPlayerStats(player: Player): Folder
	local success, savedPlayerStats = pcall(function()
		return PlayerStatsStore:GetAsync(player.UserId)
	end)

	if success then
		if savedPlayerStats then
			for key, value in pairs(PlayerStatsTemplate) do
				if savedPlayerStats[key] == nil then
					savedPlayerStats[key] = value
				end
			end
		else
			savedPlayerStats = table.clone(PlayerStatsTemplate)
		end

		local playerStats = Instance.new("Folder")
		playerStats.Name = "PlayerStats"

		local money = Instance.new("NumberValue")
		money.Name = "Money"
		money.Value = savedPlayerStats.Money
		money.Parent = playerStats

		local xp = Instance.new("NumberValue")
		xp.Name = "Xp"
		xp.Value = savedPlayerStats.Xp
		xp.Parent = playerStats

		local level = Instance.new("IntValue")
		level.Name = "Level"
		level.Value = savedPlayerStats.Level
		level.Parent = playerStats

		local inventory = Instance.new("Folder")
		inventory.Name = "Inventory"
		inventory.Parent = playerStats

		for _, itemData in ipairs(savedPlayerStats.Inventory) do
			local item = ObjectAndTableConverterService.TableToObject(itemData)
			item.Name = itemData.Name
			item.Parent = inventory
		end

		local settings = Instance.new("Folder")
		settings.Name = "Settings"
		settings.Parent = playerStats

		local binds = Instance.new("Folder")
		binds.Name = "Binds"
		binds.Parent = settings

		for bindName, keyCode in pairs(savedPlayerStats.Binds) do
			local bind = Instance.new("StringValue")
			bind.Name = bindName
			bind.Value = keyCode
			bind.Parent = binds
		end

		local equippedBackpack = Instance.new("StringValue")
		equippedBackpack.Name = "EquippedBackpack"
		equippedBackpack.Value = "Default"
		equippedBackpack.Parent = playerStats

		local backpacks = Instance.new("Folder")
		backpacks.Name = "Backpacks"
		backpacks.Parent = playerStats

		for _, backpackName in ipairs(savedPlayerStats.Backpacks) do
			local backpack = Instance.new("StringValue")
			backpack.Name = backpackName
			backpack.Value = backpackName
			backpack.Parent = backpacks
		end

		playerStats.Parent = player

		PlayerStatsService.PlayerStatsDatabase[player.UserId] = playerStats
	else
		player:Kick("An error occurred while loading your stats. Please try again later.")
		warn("Failed to load stats for player " .. player.Name .. " (UserId: " .. player.UserId .. ")")
	end
end

function PlayerStatsService.DeinitPlayerStats(player: Player)
	local playerStatsFromDataBase = PlayerStatsService.PlayerStatsDatabase[player.UserId]

	local playerStats = {
		Money = playerStatsFromDataBase.Money.Value,
		Level = playerStatsFromDataBase.Level.Value,
		Xp = playerStatsFromDataBase.Xp.Value,
		EquippedBackpack = playerStatsFromDataBase.EquippedBackpack.Value,
		Inventory = {},
		Binds = {},
		Backpacks = {},
	}

	for _, v in ipairs(playerStatsFromDataBase.Inventory:GetChildren()) do
		if v.ClassName == "Folder" then
			table.insert(playerStats.Inventory, ObjectAndTableConverterService.FolderToTable(v))
		end
	end

	print(playerStats)

	for _, bind in ipairs(playerStatsFromDataBase.Settings.Binds:GetChildren()) do
		playerStats.Binds[bind.Name] = bind.Value
	end

	for _, backpack in ipairs(playerStatsFromDataBase.Backpacks:GetChildren()) do
		table.insert(playerStats.Backpacks, backpack.Name)
	end

	local success, errorMessage = pcall(function()
		return PlayerStatsStore:SetAsync(player.UserId, playerStats)
	end)

	if not success then
		warn(
			"Failed to save stats for player " .. player.Name .. " (UserId: " .. player.UserId .. "): " .. errorMessage
		)
	end

	PlayerStatsService.PlayerStatsDatabase[player.UserId] = nil
end

return PlayerStatsService
