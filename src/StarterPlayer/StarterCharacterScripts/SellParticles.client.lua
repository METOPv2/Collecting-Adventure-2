local FruitsSold: RemoteEvent = game.ReplicatedStorage.RemoteEvents.FruitsSold

FruitsSold.OnClientEvent:Connect(function(
	userId: number,
	sold: {
		normal: boolean,
		golden: boolean,
		diamond: boolean,
	}
)
	local player = game.Players:GetPlayerByUserId(userId)
	local character = player.Character
	local sellParticlesClone = character:WaitForChild("HumanoidRootPart").SellParticles
	if player then
		for key, value in pairs(sold) do
			if value then
				if key == "normal" then
					sellParticlesClone.Green:Emit(sellParticlesClone.Green:GetAttribute("EmitCount"))
				elseif key == "golden" then
					sellParticlesClone.Gold:Emit(sellParticlesClone.Gold:GetAttribute("EmitCount"))
				elseif key == "diamond" then
					sellParticlesClone.Diamond:Emit(sellParticlesClone.Diamond:GetAttribute("EmitCount"))
				end
			end
		end
	end
end)
