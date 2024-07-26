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

for _, tree: Model in ipairs(treesHolder:GetChildren()) do
	local fruits = Instance.new("Folder")
	fruits.Name = "Fruits"
	fruits.Parent = tree

	for _, v: Part in ipairs(tree:GetChildren()) do
		if v.Name == "FruitSpawn" then
			local fruitName = tree:GetAttribute("Fruit")
			local fruit: Model = fruitsAssets:FindFirstChild(fruitName):Clone()
			fruit.Parent = fruits
			fruit:PivotTo(
				v.CFrame
					* CFrame.new(
						if v.Size.X < v.Size.Z
							then Random.new():NextNumber(-1, 1) * v.Size.X / 2
							else Random.new():NextNumber(-1, 1) * v.Size.Z,
						-v.Size.Y / 2 - fruit:GetExtentsSize().Y / 2,
						if v.Size.X > v.Size.Z
							then Random.new():NextNumber(-1, 1) * v.Size.Z / 2
							else Random.new():NextNumber(-1, 1) * v.Size.X
					)
			)

			for _, fruitPart: Part in ipairs(fruit:GetChildren()) do
				if fruitPart:IsA("BasePart") then
					fruitPart.Anchored = true
					fruitPart.CanCollide = false
					fruitPart.CanTouch = false
					fruitPart.CanQuery = false
				end
			end
		end
	end
end
