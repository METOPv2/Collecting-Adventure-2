local feedbackUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Feedback")
local textBox: TextBox = feedbackUI.Background.Holder.TextBoxHolder.TextBox
local sendIdeaButton: TextButton = feedbackUI.Background.Topbar.SendIdeaButton
local sendBugButton: TextButton = feedbackUI.Background.Topbar.SendBugButton
local sendFeedback: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SendFeedback

local debounce = false

sendIdeaButton.Activated:Connect(function()
	if textBox.Text ~= "" and not debounce then
		debounce = true
		task.delay(3, function()
			debounce = false
		end)
		sendFeedback:FireServer("Idea", textBox.Text)
	end
end)

sendBugButton.Activated:Connect(function()
	if textBox.Text ~= "" and not debounce then
		debounce = true
		task.delay(3, function()
			debounce = false
		end)
		sendFeedback:FireServer("Bug", textBox.Text)
	end
end)
