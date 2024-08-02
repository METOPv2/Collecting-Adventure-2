local inventory: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local userInputService = game:GetService("UserInputService")
local inventoryBind: StringValue = game.Players.LocalPlayer:WaitForChild("PlayerStats").Settings.Binds.InventoryUI

local function inputBegin(input, gpe)
	if gpe then
		return
	end
	if input.KeyCode == Enum.KeyCode[inventoryBind.Value] then
		inventory.Enabled = not inventory.Enabled
	end
end

userInputService.InputBegan:Connect(inputBegin)
