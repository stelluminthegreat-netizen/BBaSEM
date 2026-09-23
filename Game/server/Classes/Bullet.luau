local class = {}
class.Objects = {}
class.BulkMoveList = {}
class.__index = class

local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Include

local count = 0

local configs = script.Parent.Parent.Data.BulletConfig
local newEvent = game.ReplicatedStorage.Remotes.Events.NewBullet
local activateEvent = game.ReplicatedStorage.Remotes.Events.ActivateBullet

function class.initialize()
	BulkMove()
end

function class.new(TYPE: string)
	count += 1
	local config = shared.Libraries.Table.DeepClone(require(configs[TYPE]))
	local self = setmetatable(config, class)
	self.Id = TYPE .. count
	self.Type = TYPE

	-- self.Instance = game.ReplicatedStorage.Pools.Bullets[TYPE]:Clone()
	-- self.Instance.Parent = workspace

	class.Objects[self.Id] = self
	return self
end

function class:Initialize(pos: Vector3, dir: Vector3)
	self.CFrame = CFrame.lookAt(pos, pos + dir)
	self.StartCFrame = self.CFrame
	-- self.Instance.CFrame = self.CFrame

	shared.Classes.Threads:Spawn(function()
		task.wait(5)
		if class.Objects[self.Id] == nil then return end
		self:Destroy()
	end)
end

function class:Start()
	self.StartTick = shared.Classes.Task.Tick
	
	newEvent:FireAllClients(self.Type, self.Id, self.CFrame, self.StartTick)
	class.BulkMoveList[self.Id] = self
end

function class:DetectObstacle()
	-- Get previous CFrame
	raycastParams.FilterDescendantsInstances = shared.GameClasses.Enemy.ObjectsInstances
	local origin = self.CFrame.Position
	local direction = self.PrevCFrame.Position - origin

	local result = workspace:Raycast(origin, direction, raycastParams)
	if not result then
		return
	end
	if result.Instance.Name == "Muzzle" then return end
	if result.Instance.Name == "Barrel" then return end
	-- See if there are any results
	self.ObstaclePos = result.Position
	self:Stop()
	self:Activate()
end

function class:Stop()
	class.BulkMoveList[self.Id] = nil
end

function class:Activate()
	-- self.Instance:Destroy()
	activateEvent:FireAllClients(self.Id)
	overlapParams.FilterDescendantsInstances = shared.GameClasses.Enemy.ObjectsInstances
	local results = workspace:GetPartBoundsInBox(CFrame.new(self.ObstaclePos), self.Hitbox, overlapParams)
	local inRange = {}
	-- Filter
	for _, result in results do
		local model = shared.Libraries.Find.FindFirstAncestorWithTag(result, "Object")
		if not model then continue end
		local id = model:GetAttribute("Id")
		local class = model:GetAttribute("Class")
		local object = shared.GameClasses[class].Objects[id]
		inRange[id] = object
	end
	for id, object in inRange do
		object:IncrementHealth(-self.Dmg)
	end
	task.wait(self.DestroyDelay)
	self:Destroy()
end

function class:Destroy()
	if self.Instance then self.Instance:Destroy() end
	class.Objects[self.Id] = nil
	class.BulkMoveList[self.Id] = nil
	shared.Libraries.Table.DeepClean(self)
end

function class:Visualize()
	self.Instance.CFrame = self.CFrame
end



-- BULK
function BulkMove()
	shared.Classes.Task.OnTick:Connect(function()
		for _, bullet in class.BulkMoveList do
			if not bullet then continue end
			local current = shared.Classes.Task.Tick
			local elapsed = current - bullet.StartTick
			
			
			bullet.PrevCFrame = bullet.CFrame
			bullet.CFrame = bullet.StartCFrame + bullet.StartCFrame.LookVector * elapsed * bullet.Speed

			-- bullet:Visualize()
			bullet:DetectObstacle()	
		end
	end)
end

return class
