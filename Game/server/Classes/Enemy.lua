local class = {}
class.__index = class

class.Enemies = {}
class.BulkPivotList = {}
local enemyCount = 0

local configs = game.ServerScriptService.S_Server.Data.EnemyConfig

function class.initialize()
	BulkSetPivot()
end

function class.new(type: string)
	enemyCount += 1

	local self = setmetatable(shared.Libraries.Table.DeepClone(require(configs[type])), class)
	self.Instance = game.ReplicatedStorage.ToClone.Enemies[type]:Clone()
	self.Id = type .. tostring(enemyCount)
	self.Instance:SetAttribute("Id", self.Id)
	self.Enemies[self.Id] = self

	return self
end

function class:Init(pivot: CFrame)
	self.Instance.Parent = workspace
	self.Instance:PivotTo(pivot)
	self:CalcNextPos()
	self:CalcDirection()
end

function class:Start()
	self:Move() -- Start movement
end

function class:Move()
	class.BulkPivotList[self.Id] = self
end

function class:StopMove()
	class.BulkPivotList[self.Id] = nil
end

function class:TargetLock(target: Model)
	self.Target = target
end

function class:CalcNextPos()
	local pivot = self.Instance:GetPivot()
	self.NextPos = pivot.Position + pivot.LookVector * self.WalkSpeed
end

function class:CalcDirection()
	-- Terminate if target did not move
	local samePos = self.PreviousTargetPos == self.Target:GetPivot().Position
	if self.PreviousTargetPos and samePos then return end

	self.PreviousTargetPos = self.Target:GetPivot().Position
	self.Direction = (self.Target:GetPivot().Position - self.NextPos).Unit
end

-- Sets the Pivot of all Enemies per tick
function BulkSetPivot()
	shared.Classes.Task.OnTick:Connect(function()
		for _, enemy in class.BulkPivotList do
			-- Terminate if list is empty
			if not enemy then return end
			-- Terminate if enemy NextPos has not yet been calculated
			if not enemy.NextPos then continue end
			-- Faces enemy to its target and pivot it forward
			enemy.Instance:PivotTo(CFrame.lookAt(enemy.NextPos, enemy.NextPos + enemy.Direction))
			enemy:CalcNextPos()
			enemy:CalcDirection()
		end
	end)
end

return class
