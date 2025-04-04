local interface: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface")
local inventory: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local openInventoryButton: TextButton = interface.Buttons.Inventory.TextButton

openInventoryButton.Activated:Connect(function()
	inventory.Enabled = not inventory.Enabled
end)
