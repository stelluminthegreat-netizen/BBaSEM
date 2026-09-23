local class = {}
class.Objects = {}
class.Started = {}
class.__index = class


local configs = script.Parent.Parent.Data.Configs.BulletConfig
local newEvent = game.ReplicatedStorage.Remotes.Events.NewBullet
local activateEvent = game.ReplicatedStorage.Remotes.Events.ActivateBullet

function class.initialize()
	BulkMove()

	newEvent.OnClientEvent:Connect(function(type: string, id: string, pivot: CFrame, startTick: number)
		class.new(type, id, pivot, startTick)
	end)

	activateEvent.OnClientEvent:Connect(function(id: string)
		class.Started[id]:Activate()
	end)
end

function class.new(TYPE: string, id: string, pivot: CFrame, startTick: number)
	local config = shared.Libraries.Table.DeepClone(require(configs[TYPE]))
	local self = setmetatable(config, class)
	self.Instance = game.ReplicatedStorage.Pools.Bullets[TYPE]:Clone()
	self.Instance.CFrame = pivot
	self.StartCFrame = pivot
	self.StartTick = startTick
	self.Id = id
	class.Objects[self.Id] = self

	self:Start()

	return self
end

function class:Start()
	self.Instance.Parent = workspace
	class.Started[self.Id] = self
end

function class:Move()
	local current = shared.Classes.Task.Tick
	local elapsed = current - self.StartTick

	self.Instance.CFrame = self.StartCFrame + self.StartCFrame.LookVector * elapsed * self.Speed
end

function class:Activate()
	class.Started[self.Id] = nil
	self.Instance.Shape = "Ball"
	self.Instance.Size = Vector3.new(3, 3, 3)
	self.Instance.Transparency = 0.5
	task.wait(self.DestroyDelay)
	self:Destroy()
end

function class:Destroy()
	self.Instance:Destroy()
	shared.Libraries.Table.DeepClean(self)
end

function BulkMove()
	shared.Classes.Task.OnTick:Connect(function()
		for _, bullet in class.Started do
			if bullet.Dying then continue end

			bullet:Move()
		end
	end)
end

return class
