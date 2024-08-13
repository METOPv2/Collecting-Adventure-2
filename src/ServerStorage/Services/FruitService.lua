local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ObjectAndTableConverterService = require(ServerStorage.Source.Services.ObjectAndTableConverterService)
local Fruit = require(ReplicatedStorage.Source.Classes.Fruit)
local FruitStats = require(ReplicatedStorage.Source.Stats.Fruits)
local NotificationsService = require(game.ServerStorage.Source.Services.NotiifcationsService)
local BackpacksStats = require(game.ReplicatedStorage.Source.Stats.Backpacks)
local FruitService = {}

function FruitService.Start()
	for _, tree: Model in ipairs(workspace.Trees:GetChildren()) do
		local fruitSpawns = FruitService.GetFruitSpawns(tree)
		local fruitStats = FruitStats[tree:GetAttribute("Fruit")]
		for _, fruitSpawn in ipairs(fruitSpawns) do
			for _ = 1, FruitService.GetFruitValue(fruitStats.FruitsPerSpawn) do
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
	elseif fruitStats.FruitSpawnType == "Berrie" then
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
				* CFrame.Angles(
					math.rad(math.random(0, 360)),
					math.rad(math.random(0, 360)),
					math.rad(math.random(0, 360))
				)
		)
	end
end

function FruitService.InitializePromptOnFruit(fruit: Model)
	local fruitStats = FruitStats[fruit.Name]
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Harvest"
	prompt.HoldDuration = fruitStats.HarvestTime
	prompt.RequiresLineOfSight = false
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.Parent = fruit.PrimaryPart
	prompt.Triggered:Connect(function(player)
		local tree = fruit.Parent
		local success = FruitService.FruitHarvest(player, fruit)
		if success then
			task.wait(fruitStats.RespawnTime)
			local fruitSpawn = FruitService.GetFruitSpawn(tree)
			fruit = FruitService.CreateFruitModel(fruit.Name)
			FruitService.PositionFruitModelOnFruitSpawn(fruit, fruitSpawn)
			FruitService.InitializePromptOnFruit(fruit)
			fruit.Parent = tree
		end
	end)
end

function FruitService.GetFruitValue(value)
	return type(value) == "table" and Random.new():NextNumber(value[2], value[1]) or value
end

function FruitService.GetTakenCapacity(player: Player): number
	local takenCapacity = 0
	for _, fruit in ipairs(player.PlayerStats.Inventory:GetChildren()) do
		takenCapacity += fruit.Weight.Value
	end
	return takenCapacity
end

function FruitService.GetTakenCapacityInKG(player: Player): number
	local takenCapacity = 0
	for _, fruit in ipairs(player.PlayerStats.Inventory:GetChildren()) do
		takenCapacity += fruit.Weight.Value
	end
	return takenCapacity / 1000
end

function FruitService.GetCapacity(player: Player): number
	return BackpacksStats[player.PlayerStats.EquippedBackpack.Value].Capacity
end

function FruitService.FruitsToCapacity(fruits: { Folder }): number
	local capacity = 0
	for _, fruit in ipairs(fruits) do
		capacity += fruit.Weight.Value
	end
	return capacity
end

function FruitService.FruitHarvest(player: Player, fruit: Model)
	local equippedBackpackStats = BackpacksStats[player.PlayerStats.EquippedBackpack.Value]
	local fruitStats = FruitStats[fruit.Name]
	if FruitService.GetTakenCapacityInKG(player) < equippedBackpackStats.Capacity then
		if player.PlayerStats.Level.Value < fruitStats.LevelReq then
			return NotificationsService.Notify(
				player,
				"High level",
				string.format(
					"You need %d more levels to be able to harbest it.",
					fruitStats.LevelReq - player.PlayerStats.Level.Value
				),
				5
			)
		end
		fruit.PrimaryPart.ProximityPrompt:Destroy()
		for _, fruitPart: Part in ipairs(fruit:GetChildren()) do
			if fruitPart:IsA("BasePart") then
				fruitPart.Anchored = false
				fruitPart.CanCollide = true
			end
		end
		local att = Instance.new("Attachment")
		att.Parent = fruit.PrimaryPart
		local particles: ParticleEmitter = game.ReplicatedStorage.Assets.Particles.FruitHarvest:Clone()
		particles.Parent = att
		local att0 = Instance.new("Attachment")
		att0.CFrame = CFrame.new(fruit:GetExtentsSize().X / 2, 0, 0)
		att0.Parent = fruit.PrimaryPart
		local att1 = Instance.new("Attachment")
		att1.CFrame = CFrame.new(-fruit:GetExtentsSize().Y / 2, 0, 0)
		att1.Parent = fruit.PrimaryPart
		local trail: Trail = game.ReplicatedStorage.Assets.Trails.Fruit:Clone()
		trail.Attachment0 = att0
		trail.Attachment1 = att1
		trail.Parent = fruit.PrimaryPart
		game:GetService("Debris"):AddItem(fruit, 2)
		local fruitName = fruit.Name
		fruit = Fruit.new()
		fruit.Name = fruitName
		fruit.IsDiamond = false
		fruit.IsGolden = false
		fruit.Weight = FruitService.GetFruitValue(fruitStats.Weight)
		fruit.UniqueId = HttpService:GenerateGUID(false)
		if math.random(1, 3) == 1 then
			if math.random(1, 5) == 1 then
				fruit.IsDiamond = true
				fruit.Value *= 5
				particles.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 68, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 68, 255)),
				})
				trail.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 68, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 68, 255)),
				})
			else
				fruit.IsGolden = true
				fruit.Value *= 2
				particles.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(233, 229, 24)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(233, 229, 24)),
				})
				trail.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(233, 229, 24)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(233, 229, 24)),
				})
			end
		end
		local fruitObject = ObjectAndTableConverterService.TableToObject(fruit)
		fruitObject.Name = fruit.Name
		fruitObject.Parent = player.PlayerStats.Inventory
		particles:Emit(3)
		player.PlayerStats.Xp.Value += 1
		return true
	else
		NotificationsService.Notify(player, "Lack of capacity", "Sell your fruits to get more space.", 5)
		return false
	end
end

function FruitService.GetFruitSpawn(tree: Model): Part
	local fruitSpawns = FruitService.GetFruitSpawns(tree)
	return fruitSpawns[math.random(1, #fruitSpawns)]
end

function FruitService.SellFruits(player)
	if FruitService.GetTakenCapacityInKG(player) > 0 then
		local earned = 0
		local fruitsSold = 0
		for _, fruit in ipairs(player.PlayerStats.Inventory:GetChildren()) do
			local fruitStats = FruitStats[fruit.Name]
			player.PlayerStats.Money.Value += (fruit.Weight.Value / 1000) * fruitStats.Value
			earned += (fruit.Weight.Value / 1000) * fruitStats.Value
			fruitsSold += 1
			fruit:Destroy()
		end
		NotificationsService.Notify(
			player,
			"Fruits sold",
			string.format("You sold %d fruit%s and earned $%.2f.", fruitsSold, fruitsSold > 1 and "s" or "", earned),
			5
		)
	else
		NotificationsService.Notify(player, "No fruits", "Harvest fruits in order to sell them.", 5)
	end
end

return FruitService
