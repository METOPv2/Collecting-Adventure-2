local fruitSell: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("FruitSell")
local holder: ScrollingFrame = fruitSell.Background.Holder.ScrollingFrame
local itemTemplate: Frame = game.ReplicatedStorage.Assets.UI.InventoryItem
local inventory: Folder = game.Players.LocalPlayer:WaitForChild("PlayerStats").Inventory
local fruitAssets: Folder = game.ReplicatedStorage.Assets.Fruits
local sellAllFruits: TextButton = fruitSell.Background.Topbar.SellAll
local sellFruit: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SellFruit

local frames = {}
local connections = {}

local function AddFruit(fruit)
	local itemFrame = itemTemplate:Clone()
	itemFrame.FruitName.Text = fruit.Name
	itemFrame.Parent = holder
	itemFrame.Rarities.IsGolden.Visible = fruit.IsGolden.Value
	itemFrame.Rarities.IsDiamond.Visible = fruit.IsDiamond.Value
	local fruitModel: Model = fruitAssets:FindFirstChild(fruit.Name):Clone()
	local fruitSize = fruitModel:GetExtentsSize()
	fruitModel.Parent = itemFrame.ViewportFrame
	local camera = Instance.new("Camera")
	itemFrame.ViewportFrame.CurrentCamera = camera
	itemFrame.ViewportFrame.LightDirection = Vector3.new(-1, 0, 0)
	itemFrame.ViewportFrame.Ambient = Color3.fromRGB(234, 234, 234)
	camera.Parent = itemFrame.ViewportFrame
	camera.CFrame = CFrame.lookAt(
		fruitModel:GetPivot().Position + Vector3.new(fruitSize.X * 2, fruitSize.Y, fruitSize.Z * 2),
		fruitModel:GetPivot().Position
	)
	coroutine.wrap(function()
		while itemFrame do
			fruitModel:PivotTo(fruitModel:GetPivot() * CFrame.Angles(0, math.rad(15 * task.wait()), 0))
		end
	end)()
	local button = Instance.new("TextButton")
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Size = UDim2.fromScale(1, 1)
	button.Parent = itemFrame
	connections[fruit] = {}
	table.insert(
		connections[fruit],
		button.Activated:Connect(function()
			sellFruit:FireServer(fruit:WaitForChild("UniqueId").Value)
		end)
	)
	frames[fruit] = itemFrame
end

local function RemoveFruit(fruit)
	for _, connection in ipairs(connections[fruit]) do
		connection:Disconnect()
	end
	connections[fruit] = nil
	frames[fruit]:Destroy()
	frames[fruit] = nil
end

for _, fruit in ipairs(inventory:GetChildren()) do
	AddFruit(fruit)
end

inventory.ChildAdded:Connect(AddFruit)
inventory.ChildRemoved:Connect(RemoveFruit)
sellAllFruits.Activated:Connect(function()
	game.ReplicatedStorage.RemoteEvents.SellAllFruits:FireServer()
	fruitSell.Enabled = false
end)

while true do
	task.wait()
	if
		fruitSell.Enabled == true
		and (game.Players.LocalPlayer.Character:GetPivot().Position - workspace
				:WaitForChild("SellMan")
				:GetPivot().Position).Magnitude
			> 12
	then
		fruitSell.Enabled = false
	end
end
