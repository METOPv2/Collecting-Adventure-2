local Fruit = {}
Fruit.__index = Fruit

function Fruit.new()
	local fruit = setmetatable({}, Fruit)
	fruit.Name = "Name"
	fruit.Value = 1 / 10
	return fruit
end

function Fruit:Destroy()
	setmetatable(self, nil)
end

return Fruit
