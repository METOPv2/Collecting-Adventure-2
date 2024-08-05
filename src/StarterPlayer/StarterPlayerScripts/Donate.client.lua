local holder = workspace:WaitForChild("Donate"):WaitForChild("Part").SurfaceGui.ScrollingFrame
local templateButton: Frame = game.ReplicatedStorage.Assets.UI.DonateButtonTemplate

local products = {
	{ 5, 1899153928 },
	{ 25, 1899153930 },
	{ 50, 1899153932 },
	{ 100, 1899158369 },
	{ 200, 1899158370 },
	{ 400, 1899158367 },
	{ 800, 1899158371 },
	{ 1000, 1899158366 },
	{ 5000, 1899158365 },
	{ 10000, 1899149969 },
}

for i, data in ipairs(products) do
	local clone = templateButton:Clone()
	clone.TextLabel.Text = string.format("%d Robux", data[1])
	clone.Frame.TextButton.Activated:Connect(function()
		game:GetService("MarketplaceService"):PromptProductPurchase(game.Players.LocalPlayer, data[2])
	end)
	clone.Name = i < 10 and "1" .. i or "2" .. i
	clone.Parent = holder
end
