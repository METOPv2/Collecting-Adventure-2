local Signal = {}
Signal.__index = Signal

function Signal.new()
	local signal = {}
	signal.bind = Instance.new("BindableEvent")
	return setmetatable(signal, Signal)
end

function Signal:Fire(...)
	self.bind:Fire(...)
end

function Signal:Wait()
	self.bind.Event:Wait()
end

function Signal:Connect(...)
	local bind: BindableEvent = self.bind
	return bind.Event:Connect(...)
end

function Signal:Destroy()
	setmetatable(self, nil)
	self.bind:Destroy()
end

return Signal
