local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TreeService = {}

function TreeService.Init()
	for _, part: Part in ipairs(workspace.Trees:GetChildren()) do
		local tree: Model = TreeService.CreateTree(part.Name)
		TreeService.PositionTreeOnPart(tree, part)
		TreeService.ParentTreeToHolder(tree)
		part:Destroy()
	end
end

function TreeService.CreateTree(name: string): Model
	local trees: Folder = ReplicatedStorage.Assets.Trees:FindFirstChild(name)
	return trees:GetChildren()[math.random(1, #trees:GetChildren())]:Clone()
end

function TreeService.PositionTreeOnPart(tree: Model, part: Part)
	tree:PivotTo(
		part.CFrame
			* CFrame.new(0, tree:GetExtentsSize().Y / 2 - part.Size.Y / 2, 0)
			* CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
	)
end

function TreeService.ParentTreeToHolder(tree: Model)
	tree.Parent = workspace.Trees
end

return TreeService
