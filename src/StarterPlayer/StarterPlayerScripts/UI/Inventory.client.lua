local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local inventoryHolder: ScreenGui = Players.LocalPlayer.PlayerGui:WaitForChild("Inventory").Background.Holder
local inventoryItemTemplate: Frame = ReplicatedStorage.Assets.UI.InventoryItem
local fruitAssets: Folder = ReplicatedStorage.Assets.Fruits
local inventoryStats: Folder = game.Players.LocalPlayer:WaitForChild("PlayerStats").Inventory

local inventoryElements = {}

local function ItemAdded(item)
	local itemFrame = inventoryItemTemplate:Clone()
	itemFrame.FruitName.Text = item.Name
	itemFrame.Parent = inventoryHolder
	local fruit: Model = fruitAssets:FindFirstChild(item.Name):Clone()
	local fruitSize = fruit:GetExtentsSize()
	fruit.Parent = itemFrame.ViewportFrame
	local camera = Instance.new("Camera")
	itemFrame.ViewportFrame.CurrentCamera = camera
	itemFrame.ViewportFrame.LightDirection = Vector3.new(-1, 0, 0)
	itemFrame.ViewportFrame.Ambient = Color3.fromRGB(234, 234, 234)
	camera.Parent = itemFrame.ViewportFrame
	camera.CFrame = CFrame.lookAt(
		fruit:GetPivot().Position + Vector3.new(fruitSize.X * 2, fruitSize.Y, fruitSize.Z * 2),
		fruit:GetPivot().Position
	)
	coroutine.wrap(function()
		while itemFrame do
			fruit:PivotTo(fruit:GetPivot() * CFrame.Angles(0, math.rad(15 * task.wait()), 0))
		end
	end)()
	inventoryElements[item] = itemFrame
end

local function ItemRemoved(item)
	inventoryElements[item]:Destroy()
	inventoryElements[item] = nil
end

for _, item in ipairs(inventoryStats:GetChildren()) do
	ItemAdded(item)
end

inventoryStats.ChildAdded:Connect(ItemAdded)
inventoryStats.ChildRemoved:Connect(ItemRemoved)
