local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerStatsChangedRemoteEvent: RemoteEvent = ReplicatedStorage.RemoteEvents.PlayerStatsChanged
local GetPlayerStats: RemoteFunction = ReplicatedStorage.RemoteFunctions.GetPlayerStats
local PlayerStatsService = {
	["Players'Stats"] = {},
}
local PlayerStatsTemplate = require(script.Parent.PlayerStatsTemplate)

function PlayerStatsService.Init()
	for _, player: Player in ipairs(Players:GetPlayers()) do
		PlayerStatsService.InitializePlayerStats(player)
	end

	Players.PlayerAdded:Connect(function(player)
		PlayerStatsService.InitializePlayerStats(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		PlayerStatsService.DeinitializePlayerStats(player)
	end)

	GetPlayerStats.OnServerInvoke = function(player)
		return PlayerStatsService.GetPlayerStatsFromService(player)
	end
end

function PlayerStatsService.InitializePlayerStats(player: Player)
	local stats = PlayerStatsService.GetPlayerStatsFromDataStore()
	PlayerStatsService["Players'Stats"][player.UserId] = stats
end

function PlayerStatsService.DeinitializePlayerStats(player: Player)
	PlayerStatsService["Players'Stats"][player.UserId]:Destroy()
end

function PlayerStatsService.GetPlayerByStats(stats): Player
	for userId, v in pairs(PlayerStatsService["Players'Stats"]) do
		if v == stats then
			return Players:GetPlayerByUserId(userId)
		end
	end
end

function PlayerStatsService.GetPlayerStatsFromDataStore(): PlayerStatsTemplate.PlayerStats
	local Stats = {}
	Stats.__index = Stats

	function Stats:set(key, value)
		local player: Player = PlayerStatsService.GetPlayerByStats(self)
		local oldValue = self[key]
		self[key] = value
		PlayerStatsChangedRemoteEvent:FireClient(player, key, self[key], oldValue)
	end

	function Stats:insert(key, value)
		local player: Player = PlayerStatsService.GetPlayerByStats(self)
		local oldValue = table.clone(self[key])
		table.insert(self[key], value)
		PlayerStatsChangedRemoteEvent:FireClient(player, key, self[key], oldValue)
	end

	function Stats:get(key)
		return self[key]
	end

	function Stats:increment(key, amount)
		local player: Player = PlayerStatsService.GetPlayerByStats(self)
		local oldValue = self[key]
		self[key] += amount
		PlayerStatsChangedRemoteEvent:FireClient(player, key, self[key], oldValue)
	end

	function Stats:remove(key)
		local player: Player = PlayerStatsService.GetPlayerByStats(self)
		local oldValue = self[key]
		self[key] = nil
		PlayerStatsChangedRemoteEvent:FireClient(player, key, self[key], oldValue)
	end

	function Stats:removeTable(key, t)
		local player: Player = PlayerStatsService.GetPlayerByStats(self)
		local oldValue = table.clone(self[key])
		local i = table.find(self[key], t)
		if i then
			table.remove(self[key], i)
			PlayerStatsChangedRemoteEvent:FireClient(player, key, self[key], oldValue)
		end
	end

	function Stats:Destroy()
		setmetatable(self, nil)
		for key, _ in pairs(self) do
			self[key] = nil
		end
	end

	return setmetatable(table.clone(PlayerStatsTemplate), Stats)
end

function PlayerStatsService.GetPlayerStatsFromService(player: Player): PlayerStatsTemplate.PlayerStats
	return PlayerStatsService["Players'Stats"][player.UserId]
end

return PlayerStatsService
