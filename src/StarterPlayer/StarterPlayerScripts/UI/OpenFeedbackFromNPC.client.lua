local prompt: ProximityPrompt = workspace.FeedbackMan:WaitForChild("HumanoidRootPart").Feedback
local feedbackUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Feedback")

prompt.Triggered:Connect(function()
	feedbackUI.Enabled = not feedbackUI.Enabled
end)
