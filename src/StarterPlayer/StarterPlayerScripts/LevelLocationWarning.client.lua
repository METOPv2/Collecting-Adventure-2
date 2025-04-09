local levelLocationWarning: RemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvents").LevelLocationWarning
local locationLevelWarningUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("LocationLevelWarning")
local LocationsData = require(game.ReplicatedStorage:WaitForChild("Source").Stats.Locations)

levelLocationWarning.OnClientEvent:Connect(function(locationName)
	locationLevelWarningUI.Container.Container.TextLabel.Text =
		string.format("Level %s required.", LocationsData[locationName].Level)
	locationLevelWarningUI.Enabled = true
end)
