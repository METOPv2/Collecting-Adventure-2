local Players = game:GetService("Players")
local tradingInvitesUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("TradingInvites")
local searchTextBox: TextBox = tradingInvitesUI.Background.Search.TextBox
local playersHolder: ScrollingFrame = tradingInvitesUI.Background.Holder.ScrollingFrame
local playerTemplate: Frame = game.ReplicatedStorage.Assets.UI.TradingInvitesPlayerTemplate
local closeButton: TextButton = tradingInvitesUI.Background.Topbar.Close
local frames = {}

searchTextBox:GetPropertyChangedSignal("Text"):Connect(function()
	for _, frame in pairs(frames) do
		if searchTextBox.Text == "" or string.find(string.lower(frame.Name), string.lower(searchTextBox.Text)) then
			frame.Visible = true
		else
			frame.Visible = false
		end
	end
end)

local function AddPlayer(player: Player)
	if player == game.Players.LocalPlayer then
		return
	end
	local newFrame = playerTemplate:Clone()
	newFrame.TextButton.Activated:Connect(function()
		game.ReplicatedStorage.RemoteEvents.SendTradingInvite:FireServer(player.UserId)
	end)
	newFrame.ImageLabel.Image =
		game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	newFrame.TextLabel.Text = string.format("@%s", player.Name)
	newFrame.Name = player.Name
	newFrame.Parent = playersHolder
	frames[player] = newFrame
end

local function RemovePlayer(player: Player)
	if frames[player] then
		frames[player]:Destroy()
		frames[player] = nil
	end
end

for _, player in ipairs(game.Players:GetPlayers()) do
	AddPlayer(player)
end

Players.PlayerAdded:Connect(AddPlayer)
Players.PlayerRemoving:Connect(RemovePlayer)
closeButton.Activated:Connect(function()
	tradingInvitesUI.Enabled = false
end)
