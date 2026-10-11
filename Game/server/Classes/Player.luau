local class = {}
class.Objects = {}
class.__index = class

local remoteFunc = Instance.new("RemoteFunction")
remoteFunc.Name = "UserInput"
remoteFunc.Parent = game.ReplicatedStorage.Remotes.Functions

function class.initialize()
	game.Players.PlayerAdded:Connect(function(player)
		class.new(player)	
	end)
	for _, plr in game.Players:GetChildren() do
		if class.Objects[plr.Name] then continue end
		class.new(plr)
	end
end

function class.new(plr: Player)
	local self = setmetatable({}, class)
	self.Instance = plr
	self.Id = plr.Name
	self.Character = shared.GameClasses.Character.new(self)
	self.Character:Init()
	
	self:Init()
	return self
end

function class:Init()
	remoteFunc.OnServerInvoke = function(plr: player, key, signal: boolean)
		if key == nil then return end
		if plr ~= self.Instance then return end
		
		if signal ~= nil then key = key.Name end
		if signal == true then
			local name = key .. "_Began"
			local func = self[name]
			if not func then return end

			return func(self)
		elseif signal == false then
			local name = key .. "_Ended"
			local func = self[name]
			if not func then return end

			return func(self)
		end

		local func = self[key]
		if not func then return end
		return func(self)
	end
end

function class:LeftControl_Ended()
	self.Character:Walk()
end

function class:LeftControl_Began()
	self.Character:Run()
end

return class
