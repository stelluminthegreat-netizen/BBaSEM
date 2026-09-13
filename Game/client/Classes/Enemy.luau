local class = {}
class.Objects = {}
class.Moving = {}
class.__index = class

local actionEvent = game.ReplicatedStorage.Remotes.Events.EnemyActions
local newEvent = game.ReplicatedStorage.Remotes.Events.NewEnemy
local configs = script.Parent.Parent.Data.Configs.EnemyConfig

function class.initialize()
	BulkMove()

	newEvent.OnClientEvent:Connect(function(id: string, name: string, pivot: CFrame)
		class.new(id, name)
		class.Objects[id]:Initialize(pivot)
	end)
	actionEvent.OnClientEvent:Connect(function(id: string, action: string, direction: Vector3)
		if direction then direction = Vector3.new(direction.X, 0, direction.Z) end
		local enemy = class.Objects[id]
		enemy:SetDirection(direction)
		enemy:CalcNextPos()
	end)
end

function class.new(id, name)
	local self = setmetatable(shared.Libraries.Table.DeepClone(require(configs[name])), class)
	self.Id = id
	self.Instance = game.ReplicatedStorage.ToClone.Client.Enemies[name]:Clone()
	class.Objects[id] = self

	return self
end

function class:Initialize(pivot: CFrame)
	self.Instance:PivotTo(pivot)
	self:LoadAnims()
end

function class:LoadAnims()
	local controller = self.Instance.AnimationController
	local animator = controller.Animator

	for _, name in self.AnimNames do
		local anim = game.ReplicatedStorage.Anims[name]
		local track = animator:LoadAnimation(anim)
		self.AnimTracks[name] = track
	end
end

function class:Move()
	self.AnimTracks.Idle:Stop()
	self.AnimTracks.Walk:Play()
	class.Moving[self.Id] = self
end

function class:StopMove()
	self.AnimTracks.Walk:Stop()
	self.AnimTracks.Idle:Play()
	class.Moving[self.Id] = nil
end

function class:SetDirection(direction: Vector3)
	self.NextDirection = direction
end

function class:CalcNextPos()
	local pivot = self.Instance:GetPivot()
	self.NextPos = pivot.Position + pivot.LookVector * self.WalkSpeed
end

function class:Attack()
	self.AnimTracks.Attack:Play()
end

-- Sets the Pivot of all Enemies per tick
function BulkMove()
	shared.Classes.Task.OnTick:Connect(function()
		for _, enemy in class.Moving do
			-- Terminate if enemy NextPos/Direction has not yet been calculated
			if not enemy.NextPos then continue end
			if not enemy.Direction then continue end
			-- Faces enemy to its target and pivot it forward
			enemy.Instance:PivotTo(CFrame.lookAt(enemy.NextPos, enemy.NextPos + enemy.Direction))
			enemy:CalcNextPos()
		end
	end)
end
return class
