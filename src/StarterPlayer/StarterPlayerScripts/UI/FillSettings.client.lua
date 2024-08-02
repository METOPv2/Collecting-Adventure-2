local settings: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Settings")
local holder: ScrollingFrame = settings.Background.Holder.ScrollingFrame
local bindTemplate: Frame = game.ReplicatedStorage.Assets.UI.SettingsBindTemplate
local playerSettings: Folder = game.Players.LocalPlayer:WaitForChild("PlayerStats").Settings
local settingsStats = require(game.ReplicatedStorage.Source.Stats.Settings)

local function AddBind(value: StringValue)
	local clone = bindTemplate:Clone()
	clone.Title.Text = settingsStats[value.Name]
	clone.KeyBind.CurrentBind.TextLabel.Text = value.Value
	clone.Parent = holder

	value:GetPropertyChangedSignal("Value"):Connect(function()
		clone.KeyBind.CurrentBind.TextLabel.Text = value.Value
	end)

	local activated = false
	local connection: RBXScriptConnection = nil
	local changeButton: TextButton = clone.KeyBind.BindChanger.TextButton
	changeButton.Activated:Connect(function()
		activated = not activated
		changeButton.BackgroundColor3 = activated and Color3.fromRGB(231, 208, 2) or Color3.fromRGB(0, 172, 0)
		changeButton.Text = activated and "Press..." or "Change"

		if connection then
			connection:Disconnect()
			connection = nil
		end

		if activated then
			connection = game:GetService("UserInputService").InputBegan:Once(function(input, gpe)
				connection:Disconnect()
				connection = nil
				activated = false
				changeButton.BackgroundColor3 = activated and Color3.fromRGB(231, 208, 2) or Color3.fromRGB(0, 172, 0)
				changeButton.Text = activated and "Press..." or "Change"
				if gpe then
					return
				end
				game.ReplicatedStorage.RemoteEvents.ChangeSetting:FireServer("Binds", value.Name, input.KeyCode.Name)
			end)
		end
	end)
end

for _, value: StringValue in ipairs(playerSettings:WaitForChild("Binds"):GetChildren()) do
	AddBind(value)
end
playerSettings:WaitForChild("Binds").ChildAdded:Connect(AddBind)
