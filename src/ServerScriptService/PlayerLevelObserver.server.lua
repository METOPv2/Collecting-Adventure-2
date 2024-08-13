local Players = game:GetService("Players")
local levelUpParticles = game.ReplicatedStorage.Assets.Particles.LevelUp
local levelUpRemoteEvent: RemoteEvent = game.ReplicatedStorage.RemoteEvents.LevelUp
local connections = {}

local function LevelUp(player: Player, xp: number, lvl: IntValue): number
	if xp.Value >= (10 * (1.2 ^ lvl.Value)) then
		xp.Value -= (10 * (1.2 ^ lvl.Value))
		lvl.Value += 1
		levelUpRemoteEvent:FireAllClients(player.UserId)
		return LevelUp(player, xp, lvl)
	end
end

local function CharacterAdded(character: Model)
	local torsoParticlesClone = levelUpParticles.Torso.Attachment:Clone()
	torsoParticlesClone.Name = "LevelUpTorsoParticles"
	torsoParticlesClone.Parent = character:WaitForChild("HumanoidRootPart")

	local floorParticlesClone = levelUpParticles.Floor.Attachment:Clone()
	floorParticlesClone.Name = "LevelUpFloorParticles"
	floorParticlesClone.CFrame = CFrame.new(0, -character:GetExtentsSize().Y / 2, 0)
	floorParticlesClone.Parent = character:WaitForChild("HumanoidRootPart")
end

local function PlayerAdded(player: Player)
	local lvl: IntValue = player:WaitForChild("PlayerStats").Level
	local xp: IntValue = player:WaitForChild("PlayerStats").Xp
	connections[player] = {}
	table.insert(
		connections[player],
		xp.Changed:Connect(function()
			LevelUp(player, xp, lvl)
		end)
	)
	if player.Character then
		CharacterAdded(player.CharacterAdded)
	end
	player.CharacterAdded:Connect(CharacterAdded)
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
