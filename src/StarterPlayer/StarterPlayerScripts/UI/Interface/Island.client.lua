local island: Frame = game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface").Island
local money: NumberValue = game.Players.LocalPlayer:WaitForChild("PlayerStats").Money
local level: IntValue = game.Players.LocalPlayer:WaitForChild("PlayerStats").Level
local xp: IntValue = game.Players.LocalPlayer:WaitForChild("PlayerStats").Xp
local xpProgress = island.LevelCounter.Progress
local left = xpProgress.Left.ImageLabel.UIGradient
local right = xpProgress.Right.ImageLabel.UIGradient

local function UpdateMoney()
	island.MoneyCounter.Money.Text = string.format("$%.2f", money.Value)
end

local function UpdateLevel()
	island.LevelCounter.Level.Text = string.format("Lvl. %d", level.Value)

	local expGoal = 10 * (1.2 ^ level.Value)
	local alpha = xp.Value / expGoal

	if alpha <= 0.5 then
		right.Rotation = math.clamp(alpha / 0.5, 0, 1) * 180
		left.Rotation = -180
	else
		left.Rotation = -180 + ((alpha - 0.5) / 0.5 * 180)
		right.Rotation = 180
	end
end

UpdateMoney()
UpdateLevel()
money.Changed:Connect(UpdateMoney)
level.Changed:Connect(UpdateLevel)
xp.Changed:Connect(UpdateLevel)
