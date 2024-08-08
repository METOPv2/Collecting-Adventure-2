local equippedBackpack = game.Players.LocalPlayer:WaitForChild("PlayerStats").EquippedBackpack
local backpacksAssets = game.ReplicatedStorage.Assets.Backpacks
local currentBackpackModel = nil

local function GetTorso(): BasePart
	return script:FindFirstAncestorOfClass("Model"):WaitForChild("Torso", 3)
		or script:FindFirstAncestorOfClass("Model"):WaitForChild("UpperTorso", 3)
end

local function EquipBackpack(backpack: string)
	if currentBackpackModel then
		currentBackpackModel:Destroy()
		currentBackpackModel = nil
	end

	local backpackModel: Model = backpacksAssets:FindFirstChild(backpack):Clone()
	currentBackpackModel = backpackModel
	local torso = GetTorso()
	backpackModel:PivotTo(
		torso.CFrame
			* CFrame.new(0, 0, backpackModel:GetExtentsSize().Z / 2 + torso.Size.Z / 2)
			* CFrame.Angles(0, math.rad(180), 0)
	)
	backpackModel.Parent = script.Parent.Parent
	for _, v in ipairs(backpackModel:GetChildren()) do
		if v:IsA("BasePart") then
			local weldConstraint = Instance.new("WeldConstraint")
			weldConstraint.Part0 = v
			weldConstraint.Part1 = torso
			weldConstraint.Parent = v
		end
	end
end

EquipBackpack(equippedBackpack.Value)
equippedBackpack.Changed:Connect(EquipBackpack)
