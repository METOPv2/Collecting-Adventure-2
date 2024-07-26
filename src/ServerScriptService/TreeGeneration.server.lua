local assets = game.ReplicatedStorage.Assets
local treesAssets: Folder = assets.Trees
local treesHolder: Folder = workspace.Trees

for _, part: Part in ipairs(treesHolder:GetChildren()) do
	local fruitName = part.Name
	local trees: Folder = treesAssets:FindFirstChild(fruitName)
	local tree: Model = trees:GetChildren()[math.random(1, #trees:GetChildren())]:Clone()
	tree.Parent = workspace
	tree:PivotTo(
		part.CFrame
			* CFrame.new(0, tree:GetExtentsSize().Y / 2 - part.Size.Y / 2, 0)
			* CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
	)
	part:Destroy()
end
