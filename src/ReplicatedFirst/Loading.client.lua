local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
ReplicatedFirst:RemoveDefaultLoadingScreen()

local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 10
screenGui.ResetOnSpawn = false
screenGui.Name = "Loading"

local background = Instance.new("Frame")
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.Size = UDim2.fromScale(1, 1)
background.BorderSizePixel = 0
background.Name = "Background"
background.Parent = screenGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.fromScale(1, 1)
textLabel.BackgroundTransparency = 1
textLabel.FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
textLabel.Text = "Collecting \nAdventure 2"
textLabel.TextSize = 300
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.ZIndex = 2
textLabel.Name = "Title"
textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
textLabel.Position = UDim2.fromScale(0.5, 0.5)
textLabel.Parent = background

local stateBar = Instance.new("TextLabel")
stateBar.AnchorPoint = Vector2.new(0.5, 1)
stateBar.Position = UDim2.new(0.5, 0, 1, -10)
stateBar.Size = UDim2.fromScale(0, 0)
stateBar.BackgroundTransparency = 1
stateBar.FontFace = Font.fromId(11702779517, Enum.FontWeight.Regular, Enum.FontStyle.Italic)
stateBar.Text = "Loading"
stateBar.TextSize = 18
stateBar.AutomaticSize = Enum.AutomaticSize.XY
stateBar.TextColor3 = Color3.fromRGB(255, 255, 255)
stateBar.Parent = background

screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

task.wait(3)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

screenGui:Destroy()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
