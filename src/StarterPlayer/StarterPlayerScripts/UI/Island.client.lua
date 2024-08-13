local island: Frame = game.Players.LocalPlayer.PlayerGui:WaitForChild("Main").Island
local money: NumberValue = game.Players.LocalPlayer:WaitForChild("PlayerStats").Money
local level: IntValue = game.Players.LocalPlayer:WaitForChild("PlayerStats").Level
local xp: IntValue = game.Players.LocalPlayer:WaitForChild("PlayerStats").Xp
local status: Frame = island.LevelProgress.Status

local function UpdateMoney(newMoney)
	island.Money.TextLabel.Text = string.format("$%.2f", newMoney)
end

UpdateMoney(money.Value)
money.Changed:Connect(UpdateMoney)

local function UpdateLevel()
	island.Level.TextLabel.Text = string.format("Lvl. %d", level.Value)
	status:TweenSize(
		UDim2.fromScale(xp.Value / (10 * (1.2 ^ level.Value)), 1),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Sine,
		1
	)
end

UpdateLevel()
level.Changed:Connect(UpdateLevel)
xp.Changed:Connect(UpdateLevel)
