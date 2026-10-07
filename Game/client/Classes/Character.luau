local class = {}
class.__index = class

function class.initialize()
	game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
	class.new(game.Players.LocalPlayer)
end

function class.new(plr)
	local self = setmetatable({}, class)
	self.Player = plr
	self.Instance = plr.Character or plr.CharacterAdded:Wait()
	self:Init()
	return self
end

function class:Init()
	self.Instance.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end

return class
