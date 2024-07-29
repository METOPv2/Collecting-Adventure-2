local PlayerStatsController = require(game.ReplicatedStorage:WaitForChild("Source").Controllers.PlayerStatsController)
local island: Frame = game.Players.LocalPlayer.PlayerGui:WaitForChild("Main").Island

local function UpdateMoney(money: number)
	island.Money.TextLabel.Text = string.format("$%.2f", money)
end

local stats = PlayerStatsController:GetStats()
UpdateMoney(stats.Money)
PlayerStatsController.StatsChanged:Connect(function(key, value)
	if key == "Money" then
		UpdateMoney(value)
	end
end)
