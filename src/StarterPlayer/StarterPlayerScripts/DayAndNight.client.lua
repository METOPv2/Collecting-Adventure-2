local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local tweenIn = TweenService:Create(game.Lighting, tweenInfo, { ExposureCompensation = -3 })
local tweenOut = TweenService:Create(game.Lighting, tweenInfo, { ExposureCompensation = 0 })

local seconds = 17.6 * 60 * 60
while true do
	game.Lighting.TimeOfDay = string.format(
		"%d:%d:%d",
		math.floor(seconds / (24 * 60 * 60)),
		math.floor(seconds / (60 * 60)),
		math.floor(seconds)
	)
	seconds += 1
	if game.Lighting.ClockTime >= 17.8 or game.Lighting.ClockTime < 5.8 then
		tweenIn:Play()
	elseif game.Lighting.ClockTime >= 5.8 and game.Lighting.ClockTime < 17.8 then
		tweenOut:Play()
	end
	task.wait(3 / 60)
end
