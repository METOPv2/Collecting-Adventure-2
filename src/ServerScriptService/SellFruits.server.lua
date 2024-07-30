local sellPrompt: ProximityPrompt = workspace.SellMan.HumanoidRootPart.Sell

sellPrompt.Triggered:Connect(function(playerWhoTriggered)
	for _, fruit in ipairs(playerWhoTriggered.PlayerStats.Inventory:GetChildren()) do
		playerWhoTriggered.PlayerStats.Money.Value += fruit.Value.Value
		fruit:Destroy()
	end
end)
