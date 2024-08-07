local Lighting = game:GetService("Lighting")
Lighting.ClockTime = 7
while true do
	task.wait(1 / 60)
	Lighting.ClockTime += 1 / 1000
end
