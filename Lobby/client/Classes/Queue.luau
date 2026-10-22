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

		local state = self:RequestState()
		if state == "active" then
			-- Handle join
			local success = game.ReplicatedStorage.Remotes.Functions.RequestJoin:InvokeServer(self.Id)
			if success == true then 
				local leaveBtn = shared.Classes.UI.new("LeaveQueueBtn")
				leaveBtn.QueueId = self.Id
			end
		elseif state == "inactive" then
			-- Handle host
			if shared.Classes.UI.Objects["SizeSelector"] then return end

			local sizeSelector = shared.Classes.UI.new("SizeSelector")
			sizeSelector.QueueId = self.Id

			while self.HostSuccess == nil do
				task.wait()
			end
			if self.HostSuccess == true then
				self.HostSuccess = nil
				local leaveBtn = shared.Classes.UI.new("LeaveQueueBtn")
				leaveBtn.QueueId = self.Id
			elseif self.HostSuccess == false then
				self.HostSuccess = nil
			end
		end
	end)

	self.Conns.TouchEnded = self.Instance.Queue.TouchEnded:Connect(function()
		local items = workspace:GetPartBoundsInBox(self.Instance:GetPivot(), self.Instance.Queue.Size + Vector3.new(0.1, 0.1, 0.1))
		for _, item in items do
			if item.Name == "HumanoidRootPart" and item.Parent.Name == game.Players.LocalPlayer.Name then return end
		end
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
