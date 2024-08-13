local Players = game:GetService("Players")
local sprintParticles: ParticleEmitter = game.ReplicatedStorage.Assets.Particles.Sprint

local function CharacterAdded(character: Model)
	local attachment = Instance.new("Attachment")
	attachment.Name = "RunParticles"
	attachment.CFrame = CFrame.new(0, -character:GetExtentsSize().Y / 2, 0)
	attachment.Parent = character:WaitForChild("HumanoidRootPart")

	local currentParticles = sprintParticles:Clone()
	currentParticles.Name = "Particles"
	currentParticles.Parent = attachment
end

Players.PlayerAdded:Connect(function(player)
	if player.Character then
		CharacterAdded(player.Character)
	end
	player.CharacterAdded:Connect(CharacterAdded)
end)
