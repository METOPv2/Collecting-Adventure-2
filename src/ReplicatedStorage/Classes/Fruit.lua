local Fruit = {}
Fruit.__index = Fruit

function Fruit.new()
	local fruit = setmetatable({}, Fruit)
	fruit.Name = "Name"
	return fruit
end

function Fruit:Destroy()
	setmetatable(self, nil)
end

return Fruit
