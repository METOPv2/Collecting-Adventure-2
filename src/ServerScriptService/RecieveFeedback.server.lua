local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("Feedback")
local HttpService = game:GetService("HttpService")
local sendFeedback: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SendFeedback
local url: string =
	"https://discord.com/api/webhooks/1267560647865008140/sol9MIMtSixfRO2dsZzjbXXqU2qqaGIh-vAi1_SCikdpaJVaCQqvOoLaF4jLEh7mnl31"
local debounce = {}

sendFeedback.OnServerEvent:Connect(function(player: Player, feedback: string)
	if debounce[player.UserId] then
		return sendFeedback:FireClient(player, debounce[player.UserId])
	end
	debounce[player.UserId] = os.clock()
	local success, lastFeedback = pcall(function()
		return DataStore:GetAsync(player.UserId)
	end)
	if lastFeedback and math.abs(os.clock() - lastFeedback) <= 10 * 60 then
		return sendFeedback:FireClient(player, lastFeedback)
	end
	local data = {
		content = feedback,
		username = string.format("%s (@%s | %d)", player.DisplayName, player.Name, player.UserId),
	}
	local jsonData = HttpService:JSONEncode(data)
	success = pcall(function()
		HttpService:PostAsync(url, jsonData)
	end)
	if success then
		DataStore:SetAsync(player.UserId, os.clock())
		task.delay(10 * 60, function()
			debounce[player.UserId] = false
		end)
	end
end)
