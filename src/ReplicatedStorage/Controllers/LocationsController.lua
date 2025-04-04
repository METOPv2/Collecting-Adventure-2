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
	local gate = gates:FindFirstChild(locationName)
	if gate then
		local proximityPrompt = gate.Trigger.ProximityPrompt
		proximityPrompt.Enabled = false

		local leftHinge = gate.LeftPillar.HingeConstraint
		local rightHinge = gate.RightPillar.HingeConstraint

		leftHinge.TargetAngle = 80
		rightHinge.TargetAngle = -80
	end
end

function LocationsController.CloseGate(locationName)
	local gate = gates:FindFirstChild(locationName)
	if gate then
		local proximityPrompt = gate.Trigger.ProximityPrompt
		proximityPrompt.Enabled = false

		local leftHinge = gate.LeftPillar.HingeConstraint
		local rightHinge = gate.RightPillar.HingeConstraint

		leftHinge.TargetAngle = 0
		rightHinge.TargetAngle = -0
	end
end

return LocationsController
