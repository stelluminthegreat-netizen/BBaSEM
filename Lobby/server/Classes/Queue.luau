local class = {}
class.Objects = {}
class.__index = class
local count = 0

local requestHostRemote = Instance.new("RemoteFunction")
requestHostRemote.Parent = game.ReplicatedStorage.Remotes.Functions
requestHostRemote.Name = "RequestHost"


function class.new(instance: Part)
	count += 1
	local self = setmetatable({}, class)
	self.Id = "Queue_" .. count
	self.Instance = instance
	self.Instance.Name = self.Id

	self.Load = 0
	self.Players = {}
	self.State = "inactive"
	self.Cancelled = false

	class.Objects[self.Id] = self
	return self
end

return class
