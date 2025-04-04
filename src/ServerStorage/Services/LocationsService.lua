local LocationsService = {}

function LocationsService.Init()
	for _, gates in ipairs(workspace.Gates:GetChildren()) do
		local proximityPrompt = gates.Trigger.ProximityPrompt
		proximityPrompt.Triggered:Connect(function(player)
			local playerStats = player.PlayerStats
			if not playerStats.Locations:FindFirstChild(gates.Name) then
				-- TODO: implement purchase system for locations

				local newLocation = Instance.new("BoolValue")
				newLocation.Name = gates.Name
				newLocation.Value = true
				newLocation.Parent = playerStats.Locations
			end
		end)
	end
end

return LocationsService
