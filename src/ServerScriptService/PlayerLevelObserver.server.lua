local Players = game:GetService("Players")
local connections = {}

local function LevelUp(xp: number, lvl: IntValue): number
	if xp.Value >= (10 * (1.2 ^ lvl.Value)) then
		xp.Value -= (10 * (1.2 ^ lvl.Value))
		lvl.Value += 1
		return LevelUp(xp, lvl)
	end
end

local function PlayerAdded(player: Player)
	local lvl: IntValue = player:WaitForChild("PlayerStats").Level
	local xp: IntValue = player:WaitForChild("PlayerStats").Xp
	connections[player] = {}
	table.insert(
		connections[player],
		xp.Changed:Connect(function()
			LevelUp(xp, lvl)
		end)
	)
end

local function PlayerRemoving(player)
	for _, connection in ipairs(connections[player]) do
		connection:Disconnect()
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	PlayerAdded(player)
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)
