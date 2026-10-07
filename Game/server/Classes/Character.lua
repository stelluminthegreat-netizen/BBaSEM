local class = {}
class.__index = class

local ragdoll = shared.Libraries.Ragdoll

function class.new(player: Player)
	local self = setmetatable({}, class)
	self.Player = player
	self.Instance = player.Character or player.CharacterAdded:Wait()

	return self
end

-- Initializer
function class:Init()
	self.Instance.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	HealthChanged(self)
end

-- Listeners
function HealthChanged(self)
	self.Instance.Humanoid.Changed:Connect(function(change: string)
		if change ~= "Health" then return end

		local health = self.Instance.Humanoid.Health
		if health > 0 then return end
	end)
end


function class:Ragdoll()
	ragdoll.SetRagdoll(self.Instance, true)
end

function class:UnRagdoll()
	ragdoll.SetRagdoll(self.Instance, false)
end

return class
