local topbar: Frame = game.Players.LocalPlayer.PlayerGui:WaitForChild("Feedback").Background.Topbar
local closeButton: TextButton = topbar.CloseButton
local sendIdeaButton: TextButton = topbar.SendIdeaButton
local sendBugButton: TextButton = topbar.SendBugButton

local closeButtonTip: TextLabel = game.ReplicatedStorage.Assets.UI.FeedbackTopbarButtonsTip:Clone()
closeButtonTip.Text = "Closes a feedback window."
closeButtonTip.Visible = false
closeButtonTip.Parent = closeButton

local sendBugButtonTip: TextLabel = game.ReplicatedStorage.Assets.UI.FeedbackTopbarButtonsTip:Clone()
sendBugButtonTip.Text = "Sends feedback as a bug."
sendBugButtonTip.Visible = false
sendBugButtonTip.Parent = sendBugButton

local sendIdeaButtonTip: TextLabel = game.ReplicatedStorage.Assets.UI.FeedbackTopbarButtonsTip:Clone()
sendIdeaButtonTip.Text = "Sends feedback as an idea."
sendIdeaButtonTip.Visible = false
sendIdeaButtonTip.Parent = sendIdeaButton

closeButton.MouseEnter:Connect(function()
	closeButtonTip.Visible = true
end)

closeButton.MouseLeave:Connect(function()
	closeButtonTip.Visible = false
end)

sendBugButton.MouseEnter:Connect(function()
	sendBugButtonTip.Visible = true
end)

sendBugButton.MouseLeave:Connect(function()
	sendBugButtonTip.Visible = false
end)

sendIdeaButton.MouseEnter:Connect(function()
	sendIdeaButtonTip.Visible = true
end)

sendIdeaButton.MouseLeave:Connect(function()
	sendIdeaButtonTip.Visible = false
end)
