local settings: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Settings")
local closeButton: TextButton = settings.Background.Topbar.Close

closeButton.Activated:Connect(function()
	settings.Enabled = false
end)
