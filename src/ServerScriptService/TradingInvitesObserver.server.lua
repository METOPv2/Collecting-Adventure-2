local NotificationsService = require(game.ServerStorage.Source.Services.NotiifcationsService)
local sendTradingInviteRemoteEvent: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SendTradingInvite
local sendTradingInviteRemoteFunction: RemoteFunction = game.ReplicatedStorage.RemoteFunctions.SendTradingInvite
local startTrade: RemoteEvent = game.ReplicatedStorage.RemoteEvents.StartTrade
local connectTradingProccess: BindableEvent = game.ServerStorage.BindableEvents.ConnectTradingProccess

sendTradingInviteRemoteEvent.OnServerEvent:Connect(function(from: Player, to: number)
	local toPlayer: Player = game.Players:GetPlayerByUserId(to)
	if toPlayer then
		local result = sendTradingInviteRemoteFunction:InvokeClient(toPlayer, from.UserId)
		if result == 1 and toPlayer then
			startTrade:FireClient(from, to)
			startTrade:FireClient(toPlayer, from.UserId)
			connectTradingProccess:Fire(from, toPlayer)
		elseif result == 0 then
			NotificationsService.Notify(from, "Trade declined", "Failed to trade with @" .. toPlayer.Name, 5)
		elseif result == -1 then
			NotificationsService.Notify(
				from,
				"Receiver busy",
				string.format("@%s is already in trade.", toPlayer.Name),
				5
			)
		end
	end
end)
