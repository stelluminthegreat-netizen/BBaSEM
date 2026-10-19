local class = {}
class.__index = class
local count = 0

function class.new(instance: Part)
	count += 1

	local self = setmetatable({}, class)
	self.Instance = instance
	self.ID = "Queue_" .. count
	self.Instance:SetAttribute("Id", self.Id)
	return self
end

function class:Initialize()
	self.Conns.Touched = self.Instance.Touched:Connect(function(op: Part)
		if self.ProcessingTouch == true then return end
		self.ProcessingTouch = true
		print(op)
	end)
end




return class
