local NotificationsService = {}
local sendNotificationRemoteEvent: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SendNotification

function NotificationsService.Notify(player: Player, title: string, description: string, duration: number)
	sendNotificationRemoteEvent:FireClient(player, title, description, duration)
end

return NotificationsService
