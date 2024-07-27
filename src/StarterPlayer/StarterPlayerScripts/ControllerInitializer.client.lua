local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Controllers = ReplicatedStorage.Source.Controllers

for _, controller: ModuleScript in ipairs(Controllers:GetDescendants()) do
	if controller:IsA("ModuleScript") and controller.Name:match("Controller$") then
		controller = require(controller)
		if controller.Init then
			controller.Init()
		end
	end
end

for _, controller: ModuleScript in ipairs(Controllers:GetDescendants()) do
	if controller:IsA("ModuleScript") and controller.Name:match("Controller$") then
		controller = require(controller)
		if controller.Start then
			controller.Start()
		end
	end
end
