local Players = game:GetService("Players")
local connections = {}
local currentBackpack = {}
local function GetTorso(character): BasePart
	return character:WaitForChild("Torso", 3) or character:WaitForChild("UpperTorso", 3)
end
local function EquipBackpack(character, backpack: string)
	local player = Players:GetPlayerFromCharacter(character)
	if currentBackpack[player] then
		currentBackpack[player]:Destroy()
	end
	currentBackpack[player] = game.ReplicatedStorage.Assets.Backpacks:FindFirstChild(backpack):Clone()
	local torso = GetTorso(character)
	for _, v in ipairs(currentBackpack[player]:GetChildren()) do
		if v:IsA("BasePart") then
			local weldConstraint = Instance.new("WeldConstraint")
			weldConstraint.Part0 = v
			weldConstraint.Part1 = torso
			weldConstraint.Parent = v
		end
	end
	currentBackpack[player]:PivotTo(
		torso.CFrame
			* CFrame.new(0, 0, currentBackpack[player]:GetExtentsSize().Z / 2 + torso.Size.Z / 2)
			* CFrame.Angles(0, math.rad(180), 0)
	)
	currentBackpack[player].Parent = character
end
Players.PlayerAdded:Connect(function(player)
	connections[player] = {}
	local equippedBackpack = player:WaitForChild("PlayerStats").EquippedBackpack
	table.insert(
		connections[player],
		equippedBackpack.Changed:Connect(function()
			EquipBackpack(player.Character, equippedBackpack.Value)
		end)
	)
	if player.Character then
		EquipBackpack(player.Character, equippedBackpack.Value)
	end
	table.insert(
		connections[player],
		player.CharacterAdded:Connect(function(character)
			EquipBackpack(character, equippedBackpack.Value)
		end)
	)
end)

Players.PlayerRemoving:Connect(function(player)
	for _, connection in ipairs(connections[player]) do
		connection:Disconnect()
	end
	connections[player] = nil
end)
