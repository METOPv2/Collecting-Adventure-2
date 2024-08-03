local NotiifcationsService = {}
local sendNotificationRemoteEvent: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SendNotification

function NotiifcationsService.Notify(player: Player, title: string, description: string, duration: number)
	sendNotificationRemoteEvent:FireClient(player, title, description, duration)
end

return NotiifcationsService
