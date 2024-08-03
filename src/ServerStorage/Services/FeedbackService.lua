local FeedbackService = {}
local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("Feedback")
local HttpService = game:GetService("HttpService")
local sendFeedback: RemoteEvent = game.ReplicatedStorage.RemoteEvents.SendFeedback
local url: string =
	"https://discord.com/api/webhooks/1267560647865008140/sol9MIMtSixfRO2dsZzjbXXqU2qqaGIh-vAi1_SCikdpaJVaCQqvOoLaF4jLEh7mnl31"
local debounce = {}
local NotificationsService = require(game.ServerStorage.Source.Services.NotiifcationsService)

function FeedbackService.Init()
	sendFeedback.OnServerEvent:Connect(FeedbackService.SendFeedback)
end

function FeedbackService.SendFeedback(player: Player, feedbackMode: string, feedback: string)
	if debounce[player.UserId] then
		return NotificationsService.Notify(
			player,
			"Can't send feedback",
			string.format(
				"You can send another feedback in %d seconds.",
				10 * 60 - (os.clock() - debounce[player.UserId])
			),
			5
		)
	end
	debounce[player.UserId] = os.clock()
	local success, lastFeedback = pcall(function()
		return DataStore:GetAsync(player.UserId)
	end)
	if lastFeedback and math.abs(os.clock() - lastFeedback) <= 10 * 60 then
		return NotificationsService.Notify(
			player,
			"Can't send feedback",
			string.format("You can send another feedback in %d seconds.", 10 * 60 - (os.clock() - lastFeedback)),
			5
		)
	end
	local data = {
		content = feedback,
		username = string.format("%s (@%s | %d) [%s]", player.DisplayName, player.Name, player.UserId, feedbackMode),
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
		return NotificationsService.Notify(
			player,
			"Successfully send feedback",
			string.format("You sent %s feedback.", feedbackMode == "Idea" and "an idea" or "a bug"),
			5
		)
	end
end

return FeedbackService
