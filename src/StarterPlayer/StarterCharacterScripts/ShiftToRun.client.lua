local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local sprintParticles: ParticleEmitter = game.ReplicatedStorage.Assets.Particles.Sprint
local currentParticles: ParticleEmitter = nil
local humanoid: Humanoid = script.Parent.Parent.Humanoid
local maxStamina: IntValue = ReplicatedStorage.Stamina.MaxStamina
local currentStamina: IntValue = ReplicatedStorage.Stamina.CurrentStamina
currentStamina.Value = maxStamina.Value

local isRunning = false
local ranLastTime = os.clock()
local function StopRunning()
	currentParticles.Enabled = false
	ranLastTime = os.clock()
	humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
	isRunning = false
	task.wait(5)
	if (ranLastTime - os.clock()) >= 5 then
		return
	end
	while not isRunning and currentStamina.Value < maxStamina.Value do
		currentStamina.Value += 1
		task.wait(10 / maxStamina.Value)
	end
end

local function InitializeParticles()
	local attachment = Instance.new("Attachment")
	attachment.CFrame = CFrame.new(
		0,
		-(
				script.Parent.Parent.HumanoidRootPart.Position
				- (
					game.Players.LocalPlayer.Character:GetPivot().Position
					- Vector3.new(0, game.Players.LocalPlayer.Character:GetExtentsSize().Y / 2, 0)
				)
			).Magnitude,
		0
	)
	attachment.Parent = script.Parent.Parent.HumanoidRootPart
	currentParticles = sprintParticles:Clone()
	currentParticles.Parent = attachment
end

local function Run(name: string, state: Enum.UserInputState)
	if name == "Run" then
		if state == Enum.UserInputState.Begin then
			isRunning = true

			while isRunning do
				if currentStamina.Value == 0 then
					StopRunning()
					break
				else
					currentParticles.Enabled = true
					humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed * 2
					currentStamina.Value -= 1
					task.wait(30 / maxStamina.Value)
				end
			end
		else
			StopRunning()
		end
	end
end

ContextActionService:BindAction("Run", Run, true, Enum.KeyCode.LeftShift)
InitializeParticles()
humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
	if humanoid.FloorMaterial == Enum.Material.Air and isRunning then
		currentParticles.Enabled = false
	elseif humanoid.FloorMaterial ~= Enum.Material.Air and isRunning then
		currentParticles.Enabled = true
	end
end)
