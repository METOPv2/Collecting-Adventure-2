local LocationsService = {}
local LocationsData = require(game.ReplicatedStorage.Source.Stats.Locations)
local levelLocationWarning = game.ReplicatedStorage.RemoteEvents.LevelLocationWarning
local NotificationsService = require(game.ServerStorage.Source.Services.NotificationsService)

function LocationsService.Init()
	for _, gates in ipairs(workspace.Gates:GetChildren()) do
		local proximityPrompt = gates.Attachment.ProximityPrompt
		proximityPrompt.Triggered:Connect(function(player)
			local playerStats = player.PlayerStats

			if playerStats.Level.Value >= LocationsData[gates.Name].Level then
				local newLocation = Instance.new("BoolValue")
				newLocation.Name = gates.Name
				newLocation.Value = true
				newLocation.Parent = playerStats.Locations

				NotificationsService.Notify(
					player,
					"Location unlokced",
					string.format("Congratulations! You've unlocked a %s location.", gates.Name),
					10
				)
			else
				levelLocationWarning:FireClient(player, gates.Name)
			end
		end)
	end
end

return LocationsService
