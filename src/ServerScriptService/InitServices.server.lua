local ServerStorage = game:GetService("ServerStorage")
local Services = ServerStorage.Source.Services

for _, service: ModuleScript in ipairs(Services:GetDescendants()) do
	if service:IsA("ModuleScript") and service.Name:match("Service$") then
		service = require(service)
		if service.Init then
			service.Init()
		end
	end
end

for _, service: ModuleScript in ipairs(Services:GetDescendants()) do
	if service:IsA("ModuleScript") and service.Name:match("Service$") then
		service = require(service)
		if service.Start then
			service.Start()
		end
	end
end
