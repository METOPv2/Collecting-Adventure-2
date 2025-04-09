local locationLevelWarningUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("LocationLevelWarning")
local okButton = locationLevelWarningUI.Container.Buttons.OK

okButton.Activated:Connect(function()
	locationLevelWarningUI.Enabled = false
end)
