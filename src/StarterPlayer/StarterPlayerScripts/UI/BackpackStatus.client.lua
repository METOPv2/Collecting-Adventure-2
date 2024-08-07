local TweenService = game:GetService("TweenService")
local backpackUI: Frame = game.Players.LocalPlayer.PlayerGui:WaitForChild("Main").Backpack
local status: Frame = backpackUI.Status
local capacity: TextLabel = backpackUI.Capacity
local inventory: Folder = game.Players.LocalPlayer:WaitForChild("PlayerStats").Inventory
local equippedBackpack: Folder = game.Players.LocalPlayer:WaitForChild("PlayerStats").EquippedBackpack
local backpackStats = require(game.ReplicatedStorage.Source.Stats.Backpacks)
local lastChanged = os.clock()

local tweenInfoAppearIn = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tweenInfoDisappearOut = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tweenInfoStatus = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local function Update()
	lastChanged = os.clock()
	local backpackData = backpackStats[equippedBackpack.Value]
	TweenService:Create(status, tweenInfoStatus, {
		BackgroundColor3 = Color3.fromHSV(#inventory:GetChildren() / backpackData.Capacity, 1, 1),
		BackgroundTransparency = 0,
		Size = UDim2.fromScale(0.5, #inventory:GetChildren() / backpackData.Capacity),
	}):Play()
	TweenService:Create(backpackUI, tweenInfoAppearIn, { BackgroundTransparency = 0 }):Play()
	TweenService:Create(backpackUI.UIStroke, tweenInfoAppearIn, { Transparency = 0 }):Play()
	TweenService:Create(capacity, tweenInfoAppearIn, { BackgroundTransparency = 0, TextTransparency = 0 }):Play()
	TweenService:Create(capacity.UIStroke, tweenInfoAppearIn, { Transparency = 0 }):Play()
	capacity.Text = string.format("%d/%d", #inventory:GetChildren(), backpackData.Capacity)
	task.wait(3)
	if os.clock() - lastChanged >= 3 then
		TweenService:Create(status, tweenInfoStatus, {
			BackgroundTransparency = 1,
		}):Play()
		TweenService:Create(backpackUI, tweenInfoDisappearOut, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(backpackUI.UIStroke, tweenInfoDisappearOut, { Transparency = 1 }):Play()
		TweenService:Create(capacity, tweenInfoDisappearOut, { BackgroundTransparency = 1, TextTransparency = 1 })
			:Play()
		TweenService:Create(capacity.UIStroke, tweenInfoDisappearOut, { Transparency = 1 }):Play()
	end
end

Update()
inventory.ChildAdded:Connect(Update)
inventory.ChildRemoved:Connect(Update)
