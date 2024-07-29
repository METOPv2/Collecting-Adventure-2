local feedbackUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Feedback")
local closeButton: TextButton = feedbackUI.Background.Topbar.CloseButton

closeButton.Activated:Connect(function()
	feedbackUI.Enabled = false
end)
