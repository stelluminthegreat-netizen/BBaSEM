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

function class:AddLoad(player: Player)
	self.Players[player.Name] = player
	if self.State ~= "active" then self.State = "active" end
	self.Load += 1

	local character = player.Character
	character:PivotTo(self.Instance:GetPivot())

	return true
end

function class:StartCD()
	for i = 3, 0, -1 do
		if self.Cancel == true then break end
		task.wait(1)
		self.Instance.Billboard.CD.Text = i
	end

	
	self.State = "progress"

	local options = Instance.new("TeleportOptions")
	options.ShouldReserveServer = true

	local players = {}
	for _, player in self.Players do
		table.insert(players, player)
	end

	tpServ:TeleportAsync(117485455380700, players, options)
end

function class:Host(host: Player, queueId: string)
	local queue = class.Objects[queueId]
	queue.Size = 1
	self:AddLoad(host)
	self:StartCD()

	return true
end



return class
