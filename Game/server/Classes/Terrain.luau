local class = {}
class.__index = class

function class.initialize()
	BulkAssign()
end

function class.new()
	local self = setmetatable({}, class)
	return self
end

function BulkAssign()
	shared.Classes.Threads:Spawn(function()
		shared.Classes.Task.OnTick:Connect(function()
			local enemies = shared.GameClasses.Enemy.Objects

			for _, enemy in enemies do
				local pivot = enemy.Instance:GetPivot().Position
				local x, z = pivot.X, pivot.Z
			end
		end)
	end)
end

return class
