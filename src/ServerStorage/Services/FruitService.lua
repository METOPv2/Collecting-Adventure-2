local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ObjectAndTableConverterService = require(ServerStorage.Source.Services.ObjectAndTableConverterService)
local Fruit = require(ReplicatedStorage.Source.Classes.Fruit)
local FruitStats = require(ReplicatedStorage.Source.Stats.Fruits)
local FruitService = {}

function FruitService.Start()
	for _, tree: Model in ipairs(workspace.Trees:GetChildren()) do
		local fruitSpawns = FruitService.GetFruitSpawns(tree)
		local fruitStats = FruitStats[tree:GetAttribute("Fruit")]
		for _, fruitSpawn in ipairs(fruitSpawns) do
			for _ = 1, fruitStats.FruitsPerSpawn do
				local fruit = FruitService.CreateFruitModel(tree:GetAttribute("Fruit"))
				FruitService.PositionFruitModelOnFruitSpawn(fruit, fruitSpawn)
				FruitService.InitializePromptOnFruit(fruit)
				fruit.Parent = tree
			end
		end
	end
end

function FruitService.GetFruitSpawns(tree: Model): Part
	local fruitSpawns = {}

	for _, fruitSpawn in ipairs(tree:GetChildren()) do
		if fruitSpawn.Name == "FruitSpawn" and fruitSpawn:IsA("Part") then
			table.insert(fruitSpawns, fruitSpawn)
		end
	end

	return fruitSpawns
end

function FruitService.CreateFruitModel(name: string): Model
	return ReplicatedStorage.Assets.Fruits:FindFirstChild(name):Clone()
end

function FruitService.PositionFruitModelOnFruitSpawn(fruit: Model, spawn: Part)
	local fruitStats = FruitStats[fruit.Name]
	if fruitStats.FruitSpawnType == "UnderTreeStick" then
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
	elseif fruitStats.FruitSpawnType == "RopeConnected" then
		local attachment0 = Instance.new("Attachment")
		attachment0.Name = "Attachment0"
		attachment0.Parent = spawn

		local attachment1 = Instance.new("Attachment")
		attachment1.Name = "Attachment1"
		attachment1.Parent = fruit.PrimaryPart

		local rope = Instance.new("RopeConstraint")
		rope.Color = BrickColor.new("Earth green")
		rope.Attachment0 = attachment0
		rope.Attachment1 = attachment1
		rope.Visible = true
		rope.Parent = spawn

		fruit:PivotTo(spawn.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0))
		fruit:PivotTo(fruit:GetPivot() * CFrame.new(0, 0, math.random(5, 8)))
	end
end

function FruitService.InitializePromptOnFruit(fruit: Model)
	local fruitStats = FruitStats[fruit.Name]
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Harvest"
	prompt.HoldDuration = fruitStats.HarvestTime
	prompt.RequiresLineOfSight = false
	prompt.Parent = fruit.PrimaryPart
	prompt.Triggered:Connect(function(player)
		local tree = fruit.Parent
		FruitService.FruitHarvest(player, fruit)
		task.wait(fruitStats.RespawnTime)
		local fruitSpawn = FruitService.GetFruitSpawn(tree)
		fruit = FruitService.CreateFruitModel(fruit.Name)
		FruitService.PositionFruitModelOnFruitSpawn(fruit, fruitSpawn)
		FruitService.InitializePromptOnFruit(fruit)
		fruit.Parent = tree
	end)
end

function FruitService.FruitHarvest(player, fruit)
	fruit.PrimaryPart.ProximityPrompt:Destroy()
	for _, fruitPart: Part in ipairs(fruit:GetChildren()) do
		if fruitPart:IsA("BasePart") then
			fruitPart.Anchored = false
			fruitPart.CanCollide = true
		end
	end
	game:GetService("Debris"):AddItem(fruit, 2)
	local fruitName = fruit.Name
	local fruitStats = FruitStats[fruitName]
	fruit = Fruit.new()
	fruit.Name = fruitName
	fruit.Value = fruitStats.Value
	local fruitObject = ObjectAndTableConverterService.TableToObject(fruit)
	fruitObject.Name = fruit.Name
	fruitObject.Parent = player.PlayerStats.Inventory
end

function FruitService.GetFruitSpawn(tree: Model): Part
	local fruitSpawns = FruitService.GetFruitSpawns(tree)
	return fruitSpawns[math.random(1, #fruitSpawns)]
end

return FruitService
