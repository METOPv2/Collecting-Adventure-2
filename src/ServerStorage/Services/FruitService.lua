local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Fruit = require(ReplicatedStorage.Source.Classes.Fruit)
local FruitStats = require(ReplicatedStorage.Source.Stats.Fruits)
local FruitService = {}

function FruitService.Start()
	FruitService.PlayerStatsService = require(ServerStorage.Source.Services.PlayerStats.PlayerStatsService)

	for _, tree: Model in ipairs(workspace.Trees:GetChildren()) do
		local fruitSpawns = FruitService.GetFruitSpawns(tree)
		for _, fruitSpawn in ipairs(fruitSpawns) do
			local fruit = FruitService.CreateFruitModel(tree:GetAttribute("Fruit"))
			FruitService.PositionFruitModelOnFruitSpawn(fruit, fruitSpawn)
			FruitService.InitializePromptOnFruit(fruit)
			fruit.Parent = tree
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
	local playerStats = FruitService.PlayerStatsService.GetPlayerStatsFromService(player)
	playerStats:insert("Inventory", fruit)
end

function FruitService.GetFruitSpawn(tree: Model): Part
	local fruitSpawns = FruitService.GetFruitSpawns(tree)
	return fruitSpawns[math.random(1, #fruitSpawns)]
end

return FruitService
