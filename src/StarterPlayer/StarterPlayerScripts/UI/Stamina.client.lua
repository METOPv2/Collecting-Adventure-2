local staminaFrame: Frame = game.Players.LocalPlayer.PlayerGui:WaitForChild("Main").Island.Stamina
local maxStamina: IntValue = game.ReplicatedStorage.Stamina.MaxStamina
local currentStamina: IntValue = game.ReplicatedStorage.Stamina.CurrentStamina

local function UpdateUI()
	local alpha = currentStamina.Value / maxStamina.Value
	staminaFrame.Visible = alpha ~= 1
	staminaFrame.Size = UDim2.new(alpha / 2, 0, 0, 3)
	staminaFrame.BackgroundColor3 = Color3.fromRGB(149, 4, 4):Lerp(Color3.fromRGB(7, 155, 22), alpha)
end

UpdateUI()
currentStamina.Changed:Connect(UpdateUI)
