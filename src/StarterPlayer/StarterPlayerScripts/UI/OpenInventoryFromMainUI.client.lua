local main: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Main")
local inventory: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local openInventoryButton: TextButton = main.Buttons.Inventory.TextButton

openInventoryButton.Activated:Connect(function()
	inventory.Enabled = not inventory.Enabled
end)
