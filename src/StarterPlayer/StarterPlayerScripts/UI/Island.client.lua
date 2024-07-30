local island: Frame = game.Players.LocalPlayer.PlayerGui:WaitForChild("Main").Island
local money: NumberValue = game.Players.LocalPlayer:WaitForChild("PlayerStats").Money

local function UpdateMoney(newMoney)
	island.Money.TextLabel.Text = string.format("$%.2f", newMoney)
end

UpdateMoney(money.Value)
money.Changed:Connect(UpdateMoney)
