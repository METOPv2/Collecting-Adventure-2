local settings: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Settings")
local settingsOpenButton: TextButton =
	game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface").Buttons.Settings.TextButton

settingsOpenButton.Activated:Connect(function()
	settings.Enabled = not settings.Enabled
end)
