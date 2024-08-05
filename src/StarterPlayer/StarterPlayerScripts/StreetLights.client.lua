local streetLights = workspace:WaitForChild("StreetLights")
local streetLightsEnabled = false

local function IsItDay(): boolean
	return game.Lighting.ClockTime >= 6 and game.Lighting.ClockTime < 18
end

local function StreetLightLogic(streetLight: Model)
	streetLight:WaitForChild("LightPart").SpotLight.Enabled = not IsItDay()
	streetLight:WaitForChild("LightPart").Material = IsItDay() and Enum.Material.Plaster or Enum.Material.Neon
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
