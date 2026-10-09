local class = {}
class.Objects = {}
class.__index = class

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
	self.Character = shared.GameClasses.Character.new(self)
	return self
end

return class
