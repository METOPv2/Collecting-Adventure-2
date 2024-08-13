local NotificationsController = require(game.ReplicatedStorage.Source.Controllers.NotificationsController)
local tradingUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Trading")
local tradingInvitesUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("TradingInvites")
local inventoryUI: ScrollingFrame = tradingUI.Holder.Inventory.Holder
local player1ItemsUI: ScrollingFrame = tradingUI.Holder.Trade.Player1Items
local player2ItemsUI: ScrollingFrame = tradingUI.Holder.Trade.Player2Items
local moneySend: TextBox = tradingUI.Holder.Trade.MoneySend
local moneyReceive: TextLabel = tradingUI.Holder.Trade.MoneyReceive
local logic: TextButton = tradingUI.Holder.Trade.Topbar.Logic
local close: TextButton = tradingUI.Holder.Trade.Topbar.Close
local title: TextLabel = tradingUI.Holder.Trade.Topbar.Title
local fruitTemplate: Frame = game.ReplicatedStorage.Assets.UI.InventoryItem
local startTrade: RemoteEvent = game.ReplicatedStorage.RemoteEvents.StartTrade
local sendTradingInfo: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SendTradingInfo
local player1Confirmed: Frame = tradingUI.Holder.Trade.Player1Confirmed
local player2Confirmed: Frame = tradingUI.Holder.Trade.Player2Confirmed
local fruitAssets: Folder = game.ReplicatedStorage.Assets.Fruits
local money: NumberValue = game.Players.LocalPlayer:WaitForChild("PlayerStats").Money

local connections = {}
local player1items = {}
local player2items = {}

startTrade.OnClientEvent:Connect(function(tradeWith: number)
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	for _, item in ipairs(inventoryUI:GetChildren()) do
		if item:IsA("Frame") then
			item:Destroy()
		end
	end
	for key, frame in pairs(player1items) do
		frame:Destroy()
		player1items[key] = nil
	end
	for key, frame in pairs(player2items) do
		frame:Destroy()
		player1items[key] = nil
	end
	player1Confirmed.Visible = false
	player2Confirmed.Visible = false
	moneyReceive.Text = "$0"
	moneySend.Text = ""

	local localPlayerInventory = {}

	local tradeWithPlayer: Player = game.Players:GetPlayerByUserId(tradeWith)
	if tradeWithPlayer then
		title.Text = string.format("Trading with @%s", tradeWithPlayer.Name)
		moneySend.PlaceholderText = string.format("$%.2f", game.Players.LocalPlayer.PlayerStats.Money.Value)
		tradingUI.Enabled = true
		tradingInvitesUI.Enabled = false
		table.insert(
			connections,
			game.Players.LocalPlayer.PlayerStats.Money.Changed:Connect(function(value)
				moneySend.PlaceholderText = string.format("$%.2f", value)
			end)
		)
		table.insert(
			connections,
			close.Activated:Once(function()
				sendTradingInfo:FireServer("TradeCancelled")
				tradingUI.Enabled = false
			end)
		)
		table.insert(
			connections,
			logic.Activated:Connect(function()
				sendTradingInfo:FireServer("TradeConfirmed")
				player1Confirmed.Visible = not player1Confirmed.Visible
			end)
		)
		local function AddFruit(fruit: Folder)
			local itemFrame = fruitTemplate:Clone()
			itemFrame.FruitName.Text = fruit.Name
			itemFrame.Parent = inventoryUI
			itemFrame.Rarities.IsGolden.Visible = fruit.IsGolden.Value
			itemFrame.Rarities.IsDiamond.Visible = fruit.IsDiamond.Value
			local fruitModel: Model = fruitAssets:FindFirstChild(fruit.Name):Clone()
			local fruitSize = fruitModel:GetExtentsSize()
			fruitModel.Parent = itemFrame.ViewportFrame
			local camera = Instance.new("Camera")
			itemFrame.ViewportFrame.CurrentCamera = camera
			itemFrame.ViewportFrame.LightDirection = Vector3.new(-1, 0, 0)
			itemFrame.ViewportFrame.Ambient = Color3.fromRGB(234, 234, 234)
			camera.Parent = itemFrame.ViewportFrame
			camera.CFrame = CFrame.lookAt(
				fruitModel:GetPivot().Position + Vector3.new(fruitSize.X * 2, fruitSize.Y, fruitSize.Z * 2),
				fruitModel:GetPivot().Position
			)
			coroutine.wrap(function()
				while itemFrame do
					fruitModel:PivotTo(fruitModel:GetPivot() * CFrame.Angles(0, math.rad(15 * task.wait()), 0))
				end
			end)()
			local button = Instance.new("TextButton")
			button.Size = UDim2.fromScale(1, 1)
			button.BackgroundTransparency = 1
			button.Text = ""
			button.ZIndex = 3
			button.Parent = itemFrame
			table.insert(
				connections,
				button.Activated:Connect(function()
					if itemFrame.Parent == player1ItemsUI then
						itemFrame.Parent = inventoryUI
						sendTradingInfo:FireServer("RemovedFruit", fruit.UniqueId.Value)
					else
						itemFrame.Parent = player1ItemsUI
						sendTradingInfo:FireServer("AddedFruit", fruit.UniqueId.Value)
					end
					player1items[fruit.UniqueId.Value] = itemFrame
				end)
			)
			localPlayerInventory[fruit] = itemFrame
		end
		local function RemoveFruit(fruit)
			localPlayerInventory[fruit]:Destroy()
			localPlayerInventory[fruit] = nil
		end
		for _, fruit in ipairs(game.Players.LocalPlayer.PlayerStats.Inventory:GetChildren()) do
			AddFruit(fruit)
		end
		table.insert(connections, game.Players.LocalPlayer.PlayerStats.Inventory.ChildAdded:Connect(AddFruit))
		table.insert(connections, game.Players.LocalPlayer.PlayerStats.Inventory.ChildRemoved:Connect(RemoveFruit))
		table.insert(
			connections,
			moneySend.FocusLost:Connect(function()
				if not tonumber(moneySend.Text) then
					moneySend.Text = ""
				else
					moneySend.Text = math.round(math.clamp(tonumber(moneySend.Text), 0, money.Value) * 100) / 100
					sendTradingInfo:FireServer("MoneyChanged", math.clamp(tonumber(moneySend.Text), 0, money.Value))
				end
			end)
		)
		table.insert(
			connections,
			sendTradingInfo.OnClientEvent:Connect(function(key, value)
				if key == "AddedFruit" then
					local theFruit: Folder = nil
					for _, fruit in ipairs(tradeWithPlayer.PlayerStats.Inventory:GetChildren()) do
						if fruit.UniqueId.Value == value then
							theFruit = fruit
							break
						end
					end
					local itemFrame = fruitTemplate:Clone()
					itemFrame.FruitName.Text = theFruit.Name
					itemFrame.Parent = player2ItemsUI
					itemFrame.Rarities.IsGolden.Visible = theFruit.IsGolden.Value
					itemFrame.Rarities.IsDiamond.Visible = theFruit.IsDiamond.Value
					local fruitModel: Model = fruitAssets:FindFirstChild(theFruit.Name):Clone()
					local fruitSize = fruitModel:GetExtentsSize()
					fruitModel.Parent = itemFrame.ViewportFrame
					local camera = Instance.new("Camera")
					itemFrame.ViewportFrame.CurrentCamera = camera
					itemFrame.ViewportFrame.LightDirection = Vector3.new(-1, 0, 0)
					itemFrame.ViewportFrame.Ambient = Color3.fromRGB(234, 234, 234)
					camera.Parent = itemFrame.ViewportFrame
					camera.CFrame = CFrame.lookAt(
						fruitModel:GetPivot().Position + Vector3.new(fruitSize.X * 2, fruitSize.Y, fruitSize.Z * 2),
						fruitModel:GetPivot().Position
					)
					coroutine.wrap(function()
						while itemFrame do
							fruitModel:PivotTo(fruitModel:GetPivot() * CFrame.Angles(0, math.rad(15 * task.wait()), 0))
						end
					end)()
					player2items[theFruit] = itemFrame
					table.insert(
						connections,
						theFruit.Destroying:Connect(function()
							itemFrame:Destroy()
							player2items[theFruit] = nil
						end)
					)
				elseif key == "RemovedFruit" then
					local theFruit = nil
					for _, fruit in ipairs(tradeWithPlayer.PlayerStats.Inventory:GetChildren()) do
						if fruit.UniqueId.Value == value then
							theFruit = fruit
							break
						end
					end
					player2items[theFruit]:Destroy()
					player2items[theFruit] = nil
				elseif key == "MoveBackToInventory" then
					player1items[value].Parent = inventoryUI
				elseif key == "TradeConfirmed" then
					player2Confirmed.Visible = not player2Confirmed.Visible
				elseif key == "FinishTrade" then
					tradingUI.Enabled = false
					NotificationsController.Notify("Trade successful", "You traded with @" .. tradeWithPlayer.Name, 5)
				elseif key == "MoneyChanged" then
					moneyReceive.Text = string.format("$%.2f", value)
				end
			end)
		)
	else
		sendTradingInfo:FireServer("TradeCancelled")
	end
end)

sendTradingInfo.OnClientEvent:Connect(function(key: string)
	if key == "TradeCancelled" then
		tradingUI.Enabled = false
	end
end)
