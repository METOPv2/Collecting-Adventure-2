local assets = game.ReplicatedStorage.Assets
local treesAssets: Folder = assets.Trees
local treesHolder: Folder = workspace.Trees
local fruitsAssets: Folder = assets.Fruits

for _, part: Part in ipairs(treesHolder:GetChildren()) do
	local treeName = part.Name
	local trees: Folder = treesAssets:FindFirstChild(treeName)
	local tree: Model = trees:GetChildren()[math.random(1, #trees:GetChildren())]:Clone()
	tree.Parent = treesHolder
	tree:PivotTo(
		part.CFrame
			* CFrame.new(0, tree:GetExtentsSize().Y / 2 - part.Size.Y / 2, 0)
			* CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
	)
	part:Destroy()
end

local function CreateFruit(fruitName: string): Model
	return fruitsAssets:FindFirstChild(fruitName):Clone()
end

local function PositionFruit(fruit, spawn)
	fruit:PivotTo(
		spawn.CFrame
			* CFrame.new(
				if spawn.Size.X < spawn.Size.Z
					then Random.new():NextNumber(-1, 1) * spawn.Size.X / 2
					else Random.new():NextNumber(-1, 1) * spawn.Size.Z,
				-spawn.Size.Y / 2 - fruit:GetExtentsSize().Y / 2,
				if spawn.Size.X > spawn.Size.Z
					then Random.new():NextNumber(-1, 1) * spawn.Size.Z / 2
					else Random.new():NextNumber(-1, 1) * spawn.Size.X
			)
	)
end

local function SetupFruit(name, spawn, holder): Model
	local fruit: Model = CreateFruit(name)
	fruit.Parent = holder
	PositionFruit(fruit, spawn)

	for _, fruitPart: Part in ipairs(fruit:GetChildren()) do
		if fruitPart:IsA("BasePart") then
			fruitPart.Anchored = true
			fruitPart.CanCollide = false
			fruitPart.CanTouch = false
			fruitPart.CanQuery = false
		end
	end

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Harvest"
	prompt.Parent = fruit.PrimaryPart
	prompt.Triggered:Connect(function()
		prompt:Destroy()
		for _, fruitPart: Part in ipairs(fruit:GetChildren()) do
			if fruitPart:IsA("BasePart") then
				fruitPart.Anchored = false
				fruitPart.CanCollide = true
			end
		end
		game:GetService("Debris"):AddItem(fruit, 2)
		task.wait(10)
		fruit = SetupFruit(name, spawn)
		fruit.Parent = holder
	end)

	return fruit
end

for _, tree: Model in ipairs(treesHolder:GetChildren()) do
	local fruits = Instance.new("Folder")
	fruits.Name = "Fruits"
	fruits.Parent = tree

	for _, v: Part in ipairs(tree:GetChildren()) do
		if v.Name == "FruitSpawn" then
			local fruitName = tree:GetAttribute("Fruit")
			SetupFruit(fruitName, v, fruits)
		end
	end
end
