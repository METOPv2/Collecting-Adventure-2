local sellPrompt: ProximityPrompt = workspace:WaitForChild("SellMan"):WaitForChild("HumanoidRootPart").Sell
local fruitSell: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("FruitSell")
sellPrompt.Triggered:Connect(function()
	fruitSell.Enabled = not fruitSell.Enabled
end)
