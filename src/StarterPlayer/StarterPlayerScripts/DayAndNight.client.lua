local Lighting = game:GetService("Lighting")
while true do
	local newClock = os.clock() * 20
	local hours = math.floor((newClock % (24 * 60 * 60)) / (60 * 60))
	local minutes = math.floor((newClock % (60 * 60)) / 60)
	for seconds = 0, 59 do
		Lighting.TimeOfDay = string.format("%d:%d:%d", hours, minutes, seconds)
		task.wait(3 / 59)
	end
end
