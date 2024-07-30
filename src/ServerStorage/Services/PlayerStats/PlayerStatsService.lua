local PlayerStatsService = {}
local PlayerStatsTemplate = require(script.Parent.PlayerStatsTemplate)
local ObjectAndTableConverterService = require(game.ServerStorage.Source.Services.ObjectAndTableConverterService)

function PlayerStatsService.Init()
	for _, player: Player in ipairs(game.Players:GetPlayers()) do
		PlayerStatsService.CreatePlayersStats(player)
	end

	game.Players.PlayerAdded:Connect(PlayerStatsService.CreatePlayersStats)
end

function PlayerStatsService.CreatePlayersStats(player: Player): Folder
	local folder = ObjectAndTableConverterService.TableToObject(PlayerStatsTemplate)
	folder.Name = "PlayerStats"
	folder.Parent = player
end

return PlayerStatsService
