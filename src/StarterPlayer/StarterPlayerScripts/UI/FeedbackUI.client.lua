local feedbackUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Feedback")
local textBox: TextBox = feedbackUI.Background.Holder.TextBoxHolder.TextBox
local sendButton: TextButton = feedbackUI.Background.Send
local sendFeedback: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SendFeedback

local lastClick = os.clock()
local debounce = false

sendButton.Activated:Connect(function()
	if textBox.Text ~= "" and not debounce then
		debounce = true
		task.delay(3, function()
			debounce = false
		end)
		sendFeedback:FireServer(textBox.Text)
	end
end)

local function NumberToText(number: number)
	local minutes = (number - (number % 60)) / 60
	local seconds = number % 60
	if minutes > 0 then
		return string.format("%dm %ds", minutes, seconds)
	else
		return string.format("%ds", seconds)
	end
end

sendFeedback.OnClientEvent:Connect(function(lastFeedback)
	if os.clock() - lastClick < 1 then
		return
	end
	sendButton.BackgroundColor3 = Color3.fromRGB(169, 5, 5)
	sendButton.Text = string.format("Cooldown %s", NumberToText(10 * 60 - math.abs(os.clock() - lastFeedback)))
	task.wait(1)
	sendButton.BackgroundColor3 = Color3.fromRGB(11, 208, 90)
	sendButton.Text = "Send"
end)
