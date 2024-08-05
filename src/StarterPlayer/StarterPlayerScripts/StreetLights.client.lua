local streetLights = workspace:WaitForChild("StreetLights")
local streetLightsEnabled = false

local function IsItDay(): boolean
	return game.Lighting.ClockTime >= 6.07 and game.Lighting.ClockTime < 17.93
end

local function StreetLightLogic(streetLight: Model)
	for _, lightPart in ipairs(streetLight:GetChildren()) do
		if lightPart.Name == "LightPart" then
			lightPart.SpotLight.Enabled = not IsItDay()
			lightPart.Material = IsItDay() and Enum.Material.Plaster or Enum.Material.Neon
		end
	end
	streetLight.ChildAdded:Connect(function(child)
		if child.Name == "LightPart" then
			child.SpotLight.Enabled = not IsItDay()
			child.Material = IsItDay() and Enum.Material.Plaster or Enum.Material.Neon
		end
	end)
end

local function UpdateStreetLights()
	for _, v in ipairs(streetLights:GetChildren()) do
		StreetLightLogic(v)
	end
end
UpdateStreetLights()
streetLights.ChildAdded:Connect(StreetLightLogic)
game.Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
	if (not IsItDay() and streetLightsEnabled) or (IsItDay() and not streetLightsEnabled) then
		return
	end
	if IsItDay() and streetLightsEnabled then
		streetLightsEnabled = false
	end
	if not IsItDay() and not streetLightsEnabled then
		streetLightsEnabled = true
	end
	UpdateStreetLights()
end)
UpdateStreetLights()
