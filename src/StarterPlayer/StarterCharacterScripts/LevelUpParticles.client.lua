local Players = game:GetService("Players")
local levelUpRemoteEvent: RemoteEvent = game.ReplicatedStorage.RemoteEvents.LevelUp

levelUpRemoteEvent.OnClientEvent:Connect(function(userId: number)
	local player = Players:GetPlayerByUserId(userId)
	if player then
		local character = player.Character
		local levelUpTorsoParticles = character:WaitForChild("HumanoidRootPart").LevelUpTorsoParticles
		local levelUpFloorParticles = character:WaitForChild("HumanoidRootPart").LevelUpFloorParticles

		for _, particles: ParticleEmitter in ipairs(levelUpFloorParticles:GetChildren()) do
			particles.Enabled = true
			task.delay(2, function()
				particles.Enabled = false
			end)
		end

		for _, particles: ParticleEmitter in ipairs(levelUpTorsoParticles:GetChildren()) do
			particles:Emit(particles:GetAttribute("EmitCount"))
		end
	end
end)
