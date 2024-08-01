local inventory: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local closeButton: TextButton = inventory.Background.Topbar.CloseButton

closeButton.Activated:Connect(function()
	inventory.Enabled = false
end)
