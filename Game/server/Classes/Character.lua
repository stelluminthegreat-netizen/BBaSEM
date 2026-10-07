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

		self:Down()
	end)
end

function SwitchUI(self)
	print("Switch2")
end


function class:Ragdoll()
	ragdoll.SetRagdoll(self.Instance, true)
end

function class:UnRagdoll()
	ragdoll.SetRagdoll(self.Instance, false)
end
-- API
function class:Down()
	if self.Downed == true then return end
	self.Downed = true

	ToggleRegen(self, false)
	self.Prompt = Instance.new("ProximityPrompt", self.Instance.HumanoidRootPart)
	Ragdoll(self)
	SwitchUI(self)
end

return class
