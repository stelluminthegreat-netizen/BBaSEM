local class = {}
class.Objects = {}
class.__index = class
local count = 0

function class.initialize()
	local queue = class.new()
	queue:Initialize()
end

function class.new()
	count += 1

	local self = setmetatable({}, class)
	self.Id = "Queue_" .. count
	self.Instance = game.Workspace:FindFirstChild(self.Id)
	self.Instance:SetAttribute("Id", self.Id)
	class.Objects[self.Id] = self
	return self
end

function class:Initialize()
	self.Conns = {}
	self.Conns.Touched = self.Instance.Queue.Touched:Connect(function(op: Part)
		if self.ProcessingTouch == true then return end
		self.ProcessingTouch = true
		self:Host()
	end)
end

function class:Host()
	local remote = game.ReplicatedStorage.Remotes.Functions.RequestHost
	remote:InvokeServer(self.Id, 1)
end




return class
