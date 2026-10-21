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
	self.Touching = {}
	class.Objects[self.Id] = self
	return self
end

function class:Initialize()
	self.Conns = {}
	self.Conns.Touched = self.Instance.Queue.Touched:Connect(function(op: Part)
		if op.Name ~= "HumanoidRootPart" then return end

		local players = self:RequestPlayerList()
		local playerName = op.Parent.Name
		if players[playerName] then return end
		if game.Players.LocalPlayer.Name ~= playerName then return end
		if self.Touching[playerName] then return end
		self.Touching[playerName] = true

	self.Conns.TouchEnded = self.Instance.Queue.TouchEnded:Connect(function()
		self.Touching[game.Players.LocalPlayer.Name] = nil
	end)
end

function class:RequestState()
	local remote = game.ReplicatedStorage.Remotes.Functions.RequestState
	local state = remote:InvokeServer(self.Id)
	
	return state
end

function class:RequestPlayerList()
	return game.ReplicatedStorage.Remotes.Functions.RequestPlayers:InvokeServer(self.Id)
end

return class
