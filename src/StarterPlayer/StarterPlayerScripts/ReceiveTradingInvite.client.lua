local sendTradingInvite: RemoteFunction = game.ReplicatedStorage.RemoteFunctions.SendTradingInvite
local tradingPrompt: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("TradingPrompt")
local activePrompt = nil

sendTradingInvite.OnClientInvoke = function(from: number)
	if activePrompt then
		return -1
	end
	activePrompt = from
	local player: Player = game.Players:GetPlayerByUserId(from)
	local result = false
	local connection1, connection2 = nil, nil
	if player then
		tradingPrompt.Holder.Title.Text = string.format("Trade invite from @%s", player.Name)
		tradingPrompt.Enabled = true
		connection1 = tradingPrompt.Holder.Accept.Activated:Once(function()
			tradingPrompt.Enabled = false
			result = 1
		end)
		connection2 = tradingPrompt.Holder.Decline.Activated:Once(function()
			tradingPrompt.Enabled = false
			result = 0
		end)
	else
		result = 0
	end
	repeat
		task.wait()
	until result
	if connection1 then
		connection1:Disconnect()
	end
	if connection2 then
		connection2:Disconnect()
	end
	activePrompt = nil
	return result
end
