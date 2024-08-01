local inventory: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local userInputService = game:GetService("UserInputService")

local function inputBegin(input, gpe)
	if gpe then
		return
	end
	if input.KeyCode == Enum.KeyCode.Q then
		inventory.Enabled = not inventory.Enabled
	end
end

userInputService.InputBegan:Connect(inputBegin)
