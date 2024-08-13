local fruitSell: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("FruitSell")
local closeButton: TextButton = fruitSell.Background.Topbar.Close
closeButton.Activated:Connect(function()
	fruitSell.Enabled = false
end)
