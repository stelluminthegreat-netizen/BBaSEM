local class = {}
class.__index = class
class.HasTarget = {}
class.NoTarget = {}
class.Objects = {}
local turretCount = 0

local configs = game.ServerScriptService.S_Server.Data.TurretConfig

local RegionsHandler 
shared.Classes.Threads:Spawn(function()
	while not RegionsHandler do
		RegionsHandler = shared.GameClasses.RegionsHandler
		task.wait()
	end
end)

function class.start()
	BulkAttack()
	BulkFindTarget()
end

function class.new(type: string)
	turretCount += 1
	local self = setmetatable(shared.Libraries.Table.DeepClone(require(configs[type])), class)
	self.Instance = game.ReplicatedStorage.ToClone.Turrets[type]:Clone()
	self.Id = type .. turretCount
	self.Instance:SetAttribute("Id", self.Id)
	class.Objects[self.Id] = self

	return self
end

function class:Init(position: Vector3)
	self:InitEvents()
	shared.Entities[self.Id] = self
	self.Instance.Parent = workspace
	self.Instance:PivotTo(self.Instance:GetPivot() - self.Instance:GetPivot().Position + position)
end

function class:InitEvents()
	for _, name in self.EventNames do
		local event = shared.Classes.Event.new()
		self.Events[name] = event
	end
end

function class:Start()
	task.wait()
	class.NoTarget[self.Id] = self
end

function class:FindTarget()
	if self.Target then 
		class.HasTarget[self.Id] = self
		class.NoTarget[self.Id] = nil
		return
	end

	local pivot = self.Instance:GetPivot()
	local x, z = pivot.X, pivot.Z
	local result = RegionsHandler:Get(x, z, "Enemy", self.Range)
	local inRange = {}
	for _, tbl in result do
		for _, item in tbl do
			table.insert(inRange, item)
		end
	end
	for _, target in inRange do
		if not target then continue end
		if not self.PrevTargDist then self.PrevTargDist = 100 end
		if target.Instance.Parent ~= workspace then continue end
		

		local distance = target.Instance:GetPivot().Position - pivot.Position
		local x, z = distance.X, distance.Z
		local hypo = math.sqrt(x * x + z * z)
		if hypo > self.PrevTargDist then continue end
		self.PrevTargDist = hypo
		self:TargetLock(target)
	end
end

function class:TargetLock(target)
	self.Target = target
	self:MonitorTarget()
	class.HasTarget[self.Id] = self
	class.NoTarget[self.Id] = nil
end

function class:Aim()
	if not self.Target then
		class.HasTarget[self.Id] = nil
		class.NoTarget[self.Id] = self
		return
	end
	-- local ref = self.Instance.Ref
	-- local yawHinge = self.Instance.Base.YawHingePart.YawHinge
	-- local pitchHinge = self.Instance.Housing.Stand.PitchHingePart.PitchHinge

	local ref = self.Instance.Ref
	local yawHinge = self.Instance:FindFirstChild("YawHinge", true)
	local pitchHinge = self.Instance:FindFirstChild("PitchHinge", true)

	local direction = ref.CFrame:PointToObjectSpace(self.Target.Instance.Head.Position)

	local flatDirection = direction * Vector3.new(1, 0, 1)
	yawHinge.TargetAngle =  -math.deg(Vector3.zAxis:Angle(flatDirection, Vector3.yAxis))

	local axis = Vector3.yAxis:Cross(flatDirection)
	pitchHinge.TargetAngle = -math.deg(flatDirection:Angle(direction, axis))
end

function class:Fire()
	local targetDirection = (self.Target.Instance.Head.Position - self.Instance.Ref.Position).Unit
	local look = self.Instance.Housing.Gun.Barrel.CFrame.LookVector
	local dot = look:Dot(targetDirection)
	if dot < 0.9999 then return end
	if self.Status.Attacking == true then return end
	self.Status.Attacking = true
	-- self.Target:IncrementHealth(-self.Dmg)	
	local bullet = shared.GameClasses.Bullet.new(self.BulletType)
	local muzzleCFrame = self.Instance.Housing.Gun.Muzzle.CFrame
	bullet:Initialize(muzzleCFrame.Position, muzzleCFrame.LookVector)
	bullet:Start()
	task.wait(self.AttackInterval)
	self.Status.Attacking = false
end

function class:MonitorTarget()
	if not self.Target then return end
	self.Conns["MonitorTarg"] = self.Target.Events.Died:Connect(function()
		self.Target = nil
		class.NoTarget[self.Id] = self
		class.HasTarget[self.Id] = nil
		self.PrevTargDist = 100
		self.Conns["MonitorTarg"]:Disconnect()
	end)
end

function BulkAttack()
	shared.Classes.Task.OnTick:Connect(function()
		for _, turret in class.HasTarget do
			turret:Aim()
			turret:Fire()
		end
	end)
end

function BulkFindTarget()
	shared.Classes.Task.OnTick:Connect(function()
		for _, turret in class.NoTarget do
			turret:FindTarget()
		end
	end)
end
-- APIs
function class:IncrementHealth(n: number)
	self.Health += n
	if self.Health > 0 then return end

	self:Die()
end

function class:Die()
	
		-- Do death stuff like animations 
	shared.Entities[self.Id] = nil

	class.Objects[self.Id] = nil
	class.NoTarget[self.Id] = nil
	class.HasTarget[self.Id] = nil

	local x, z = self.PreviousCoords.x, self.PreviousCoords.z
	shared.GameClasses.RegionsHandler:Remove(x, z, self, "Turret")

	for _, child in self.Instance:GetChildren() do
		if not child:IsA("BasePart") then continue end
		shared.Classes.Threads:Spawn(function()
			while child.Transparency ~= 1 do
				child.Transparency += 0.1
				task.wait(0.1)
			end
		end)
	end
	self.Events.Died:Fire()
	self.Target = nil

	self.Events.Destroyed:Fire()
	self:Destroy()
end

function class:Destroy()
	for name, conn in self.Conns do conn:Disconnect() self.Conns[name] = nil end
	for name, _ in self.Events do self.Events[name] = nil end
	
	self.Instance:Destroy()
	shared.Libraries.Table.DeepClean(self)
end

return class
