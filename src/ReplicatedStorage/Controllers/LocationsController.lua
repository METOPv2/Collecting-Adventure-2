local LocationsController = {}
local player = game.Players.LocalPlayer
local playerStats = player:WaitForChild("PlayerStats")
local gates = workspace:WaitForChild("Gates")

function LocationsController.Init()
	local playerLocations = playerStats.Locations

	for _, location in ipairs(playerLocations:GetChildren()) do
		LocationsController.OpenGate(location.Name)
	end

	playerLocations.ChildAdded:Connect(function(location)
		LocationsController.OpenGate(location.Name)
	end)

	playerLocations.ChildRemoved:Connect(function(location)
		LocationsController.CloseGate(location.Name)
	end)
end

function LocationsController.OpenGate(locationName)
	local gate = gates:WaitForChild(locationName)
	gate.Transparency = 1
	gate.CanCollide = false
	gate.Attachment.ProximityPrompt.Enabled = false
end

function LocationsController.CloseGate(locationName)
	local gate = gates:WaitForChild(locationName)
	gate.Transparency = 0.5
	gate.CanCollide = true
	gate.Attachment.ProximityPrompt.Enabled = true
end

return LocationsController
