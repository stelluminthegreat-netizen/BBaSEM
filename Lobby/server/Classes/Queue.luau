local class = {}
class.Objects = {}
class.__index = class
local count = 0

local requestHostRemote = Instance.new("RemoteFunction")
requestHostRemote.Parent = game.ReplicatedStorage.Remotes.Functions
requestHostRemote.Name = "RequestHost"

local requestStateRemote = Instance.new("RemoteFunction")
requestStateRemote.Parent = game.ReplicatedStorage.Remotes.Functions
requestStateRemote.Name = "RequestState"

local requestLeaveRemote = Instance.new("RemoteFunction")
requestLeaveRemote.Parent = game.ReplicatedStorage.Remotes.Functions
requestLeaveRemote.Name = "RequestLeave"

local requestPlayersRemote = Instance.new("RemoteFunction")
requestPlayersRemote.Parent = game.ReplicatedStorage.Remotes.Functions
requestPlayersRemote.Name = "RequestPlayers"

local requestJoinRemote = Instance.new("RemoteFunction")
requestJoinRemote.Parent = game.ReplicatedStorage.Remotes.Functions
requestJoinRemote.Name = "RequestJoin"

local tpServ = game:GetService("TeleportService")

function class.initialize()
	class.new(game.Workspace.Queue)
	requestHostRemote.OnServerInvoke = function(plr: Player, id: string, size: number)
		return class.Objects[id]:Host(plr, id, size)
	end

	requestStateRemote.OnServerInvoke = function(plr: Player, id: string)
		return class.Objects[id]:RespondStateRequest()
	end

	requestLeaveRemote.OnServerInvoke = function(plr: Player, id: string)
		return class.Objects[id]:RemoveLoad(plr)
	end

	requestPlayersRemote.OnServerInvoke = function(_, id)
		return class.Objects[id].Players
	end

	requestJoinRemote.OnServerInvoke = function(plr: Player, id: string)
		return class.Objects[id]:RequestJoin(plr)
	end
end

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

function class:RespondStateRequest()
	return self.State
end

function class:AddLoad(player: Player)
	self.Players[player.Name] = player
	if self.State ~= "active" then self.State = "active" end
	self.Load += 1
	self.LoadText = self.Load .. "/" .. self.Size
	self:UpdBillboard()

	local character = player.Character
	character:PivotTo(self.Instance:GetPivot())

	return true
end

function class:RemoveLoad(player: Player)
	self.Players[player.Name] = nil
	self.Load -= 1
	self.LoadText = self.Load .. "/" .. self.Size
	self:UpdBillboard()
	local character = player.Character
	character:PivotTo(CFrame.new(Vector3.zero))
	if self.Load <= 0 then
		self.Load = 0
		self:CancelCD()
	end
end

function class:RequestJoin(player)
	if self.Load >= self.Size then return false end
	self:AddLoad(player)
	return true
end

function class:CancelCD()
	shared.Classes.Threads:Spawn(function()
		self.Cancel = true
		self.State = "cancelling"
		task.wait(1.5)
		self.State = "inactive"
		self.Cancel = false
	end)
end

function class:Unload()
	table.clear(self.Players)
end

function class:StartCD()
	for i = 30, 0, -1 do
		if self.Cancel == true then self.Instance.Billboard.CD.Text = "Frees" return end
		self.CD = i
		self:UpdBillboard()
		task.wait(1)
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
