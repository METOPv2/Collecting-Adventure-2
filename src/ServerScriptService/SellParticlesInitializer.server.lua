local Players = game:GetService("Players")

local function CharacterAdded(character)
	local sellParticles: Part = game.ReplicatedStorage.Assets.Particles.SellParticles
	local att: Attachment = sellParticles.Attachment:Clone()
	att.Name = "SellParticles"
	att.CFrame = CFrame.new(0, -character:GetExtentsSize().Y / 2, 0)
	att.Parent = character:WaitForChild("HumanoidRootPart")
end

Players.PlayerAdded:Connect(function(player)
	if not player.Character then
		player.CharacterAdded:Connect(CharacterAdded)
	else
		CharacterAdded(player.Character)
	end
end)
