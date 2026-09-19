local class = {}
class.Objects = {}
class.__index = class

function class.new(parent: BasePart, maxHealth: number)
	local self = setmetatable({}, class)
	self.Parent = parent
	self.MaxHealth = maxHealth
	self.Instance = game.ReplicatedStorage.ToClone.Client.UIs.HealthBar:Clone()
	self.Instance.Parent = parent

	self:ChangeHealth(maxHealth)
	
	return self
end

function class:ChangeHealth(currentHealth: number)
	-- Calculate
	local unit = currentHealth / self.MaxHealth
	local size = UDim2.fromScale(unit, 1)
	-- Apply to ui
	self.Instance.Health.Size = size
	self.Instance.Count.Text = currentHealth .. " / " ..  self.MaxHealth
end

return class
