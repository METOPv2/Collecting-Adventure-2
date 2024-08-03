local NotificationsController = {}
local notificationTemplate = game.ReplicatedStorage:WaitForChild("Assets").UI.NotificationTemplate
local notificationsHolder = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main").Notifications
local sendNotificationRemoteEvent: RemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvents").SendNotification

local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

function NotificationsController.Init()
	sendNotificationRemoteEvent.OnClientEvent:Connect(NotificationsController.Notify)
end

function NotificationsController.Notify(title: string, description: string, duration: number)
	local clone: Frame = notificationTemplate:Clone()
	clone.Holder.Title.Text = title
	clone.Holder.Description.Text = description
	clone.Holder.Position = UDim2.fromScale(1, 0)
	clone.Parent = notificationsHolder

	local tweenIn = tweenService:Create(clone.Holder, tweenInfo, { Position = UDim2.fromScale(0, 0) })
	tweenIn:Play()
	tweenIn.Completed:Wait()
	task.delay(duration, function()
		local tweenOut = tweenService:Create(clone.Holder, tweenInfo, { Position = UDim2.fromScale(1, 0) })
		tweenOut:Play()
		tweenOut.Completed:Wait()
		clone:Destroy()
	end)
end

return NotificationsController
