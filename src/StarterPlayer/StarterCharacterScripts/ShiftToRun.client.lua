local ContextActionService = game:GetService("ContextActionService")
local StarterPlayer = game:GetService("StarterPlayer")
local localHumanoid: Humanoid = script:FindFirstAncestorOfClass("Model"):WaitForChild("Humanoid")
local currentStamina: IntValue = game.ReplicatedStorage.Stamina.CurrentStamina
local maxStamina: IntValue = game.ReplicatedStorage.Stamina.MaxStamina
local lastRun = os.clock()
local isRunning = false
local isIdle = false

currentStamina.Value = maxStamina.Value

local function Run(name, state)
	if name ~= "Run" then
		return
	end

	if state == Enum.UserInputState.Begin then
		localHumanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed * 2
		isRunning = true
		while isRunning and currentStamina.Value > 0 and not isIdle do
			currentStamina.Value -= 1
			task.wait(30 / maxStamina.Value)
		end
		localHumanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
		isRunning = false
		lastRun = os.clock()
		task.wait(3)
		while currentStamina.Value < maxStamina.Value and not isRunning do
			if (os.clock() - lastRun) >= 3 then
				currentStamina.Value += 1
				task.wait(10 / maxStamina.Value)
			end
		end
	else
		localHumanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
		isRunning = false
	end
end

ContextActionService:BindAction("Run", Run, true, Enum.KeyCode.LeftShift)
ContextActionService:SetTitle("Run", "Run")
ContextActionService:SetPosition("Run", UDim2.new(1, -200, 1, -150))
