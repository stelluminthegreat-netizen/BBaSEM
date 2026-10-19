local class = {}
class.__index = class
local count = 0

local requestHostRemote = Instance.new("RemoteFunction")
requestHostRemote.Parent = game.ReplicatedStorage.Remotes.Functions
requestHostRemote.Name = "RequestHost"

	local self = setmetatable({}, class)
	return self
end

return class
