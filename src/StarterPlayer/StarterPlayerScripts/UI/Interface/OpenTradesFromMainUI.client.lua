local tradeButton: TextButton = game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface").Buttons.Trading.TextButton
local tradeUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("TradingInvites")

tradeButton.Activated:Connect(function()
	tradeUI.Enabled = not tradeUI.Enabled
end)
