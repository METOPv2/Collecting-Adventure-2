local Players = game:GetService("Players")
local sendTradingInfo: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SendTradingInfo
local connectTradingProccess: BindableEvent = game.ServerStorage.BindableEvents.ConnectTradingProccess
local NotificationsService = require(game.ServerStorage.Source.Services.NotiifcationsService)
local BackpackStats = require(game.ReplicatedStorage.Source.Stats.Backpacks)
local trades = {}

local function CancelTrade(tradeKey, trade, whoCancelled)
	if not whoCancelled then
		return
	end
	local player1: Player = game.Players:GetPlayerByUserId(trade.player1UserId)
	local player2: Player = game.Players:GetPlayerByUserId(trade.player2UserId)
	if player1 then
		NotificationsService.Notify(player1, "Trade cancelled", "The trade was cancelled by @" .. whoCancelled.Name, 5)
	end
	if player2 then
		NotificationsService.Notify(player2, "Trade cancelled", "The trade was cancelled by @" .. whoCancelled.Name, 5)
	end
	trades[tradeKey] = nil
	sendTradingInfo:FireClient(player1 ~= whoCancelled and player1 or player2, "TradeCancelled")
end

local function FindFruitByUniqueId(player: Player, uniqueId: string): Folder?
	for _, fruit in ipairs(player.PlayerStats.Inventory:GetChildren()) do
		if fruit.UniqueId.Value == uniqueId then
			return fruit
		end
	end
end

local function FinishTrade(tradeKey, trade)
	local player1 = game.Players:GetPlayerByUserId(trade.player1UserId)
	local player2 = game.Players:GetPlayerByUserId(trade.player2UserId)
	if player1 and player2 then
		player1.PlayerStats.Money.Value += trade.player2Money
		player1.PlayerStats.Money.Value -= trade.player1Money
		player2.PlayerStats.Money.Value += trade.player1Money
		player2.PlayerStats.Money.Value -= trade.player2Money
		for _, uniqueId in pairs(trade.player1Items) do
			local fruit = FindFruitByUniqueId(player1, uniqueId)
			if fruit then
				fruit.Parent = player2.PlayerStats.Inventory
			end
		end
		for _, uniqueId in pairs(trade.player2Items) do
			local fruit = FindFruitByUniqueId(player2, uniqueId)
			if fruit then
				fruit.Parent = player1.PlayerStats.Inventory
			end
		end
		trades[tradeKey] = nil
	else
		CancelTrade(tradeKey, trade, player1 and player1 or player2)
	end
end

connectTradingProccess.Event:Connect(function(player2, player1)
	trades[player1.UserId .. player2.UserId] = {
		player1Items = {},
		player2Items = {},
		player1UserId = player1.UserId,
		player2UserId = player2.UserId,
		player1confirmed = false,
		player2confirmed = false,
		player1Money = 0,
		player2Money = 0,
	}
end)

sendTradingInfo.OnServerEvent:Connect(function(player, key: string, value1: any)
	if key == "TradeCancelled" then
		for tradeKey, trade in pairs(trades) do
			if string.find(tradeKey, player.UserId) then
				CancelTrade(tradeKey, trade, player)
			end
		end
	elseif key == "AddedFruit" or key == "RemovedFruit" then
		for tradeKey, trade in pairs(trades) do
			if string.find(tradeKey, player.UserId) then
				local receiver = game.Players:GetPlayerByUserId(
					trade.player1UserId == player.UserId and trade.player2UserId or trade.player1UserId
				)
				if receiver then
					if key == "AddedFruit" then
						local items = nil
						if player.UserId == trade.player1UserId then
							items = trade.player1Items
						else
							items = trade.player2Items
						end
						if
							#items + #receiver.PlayerStats.Inventory:GetChildren()
							< BackpackStats[receiver.PlayerStats.EquippedBackpack.Value].Capacity
						then
							table.insert(items, value1)
							sendTradingInfo:FireClient(receiver, key, value1)
						else
							NotificationsService.Notify(player, "Error", "Receiver have not enough capacity.", 5)
							sendTradingInfo:FireClient(player, "MoveBackToInventory", value1)
						end
					else
						if player.UserId == trade.player1UserId then
							table.remove(trade.player1Items, table.find(trade.player1Items, value1))
						else
							table.remove(trade.player2Items, table.find(trade.player1Items, value1))
						end
						sendTradingInfo:FireClient(receiver, key, value1)
					end
				else
					CancelTrade(tradeKey, trade, player)
				end
			end
		end
	elseif key == "TradeConfirmed" then
		for tradeKey, trade in pairs(trades) do
			if string.find(tradeKey, player.UserId) then
				if player.UserId == trade.player1UserId then
					trade.player1confirmed = not trade.player1confirmed
					local player2 = game.Players:GetPlayerByUserId(trade.player2UserId)
					if player2 then
						if trade.player1confirmed and trade.player2confirmed then
							sendTradingInfo:FireClient(player2, "FinishTrade")
							sendTradingInfo:FireClient(player, "FinishTrade")
							FinishTrade(tradeKey, trade)
						else
							sendTradingInfo:FireClient(player2, "TradeConfirmed")
						end
					else
						CancelTrade(tradeKey, trade, player)
					end
				else
					trade.player2confirmed = not trade.player2confirmed
					local player1 = game.Players:GetPlayerByUserId(trade.player1UserId)
					if player1 then
						if trade.player1confirmed and trade.player2confirmed then
							sendTradingInfo:FireClient(player1, "FinishTrade")
							sendTradingInfo:FireClient(player, "FinishTrade")
							FinishTrade(tradeKey, trade)
						else
							sendTradingInfo:FireClient(player1, "TradeConfirmed")
						end
					else
						CancelTrade(tradeKey, trade, player)
					end
				end
			end
		end
	elseif key == "MoneyChanged" then
		for tradeKey, trade in pairs(trades) do
			if string.find(tradeKey, player.UserId) then
				sendTradingInfo:FireClient(
					game.Players:GetPlayerByUserId(
						player.UserId == trade.player1UserId and trade.player2UserId or trade.player1UserId
					),
					"MoneyChanged",
					value1
				)
				if player.UserId == trade.player1UserId then
					trade.player1Money = value1
				else
					trade.player2Money = value1
				end
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	for tradeKey, trade in pairs(trades) do
		if string.find(player.UserId, tradeKey) then
			CancelTrade(trade, player)
		end
	end
end)
