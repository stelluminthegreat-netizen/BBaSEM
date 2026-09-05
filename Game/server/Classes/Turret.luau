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

function class:Init()
	shared.Entities[self.Id] = self
	self.Instance.Parent = workspace
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
	print(result)
	for _, target in inRange do
		if not target then continue end
		if not self.PrevTargDist then self.PrevTargDist = 0 end
		if target.Parent ~= workspace then continue end

		local distance = target.Position - pivot.Position
		local x, z = distance.X, distance.Z
		local hypo = math.sqrt(x * x + z * z)
		if hypo > self.PrevTargDist then continue end

		self.PrevTargDist = hypo
		self:TargetLock(target)
	end
end

function class:TargetLock(target)
	self.Target = target
	class.HasTarget[self.Id] = self
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

	local direction = ref.CFrame:PointToObjectSpace(self.Target.Position)

	local flatDirection = direction * Vector3.new(1, 0, 1)
	yawHinge.TargetAngle =  -math.deg(Vector3.zAxis:Angle(flatDirection, Vector3.yAxis))

	local axis = Vector3.yAxis:Cross(flatDirection)
	pitchHinge.TargetAngle = math.deg(flatDirection:Angle(-direction, axis))
end

function class:Fire()
	local targetDirection =  (self.Target.Position - self.Instance.Ref.Position).Unit
	local look = self.Instance.Housing.Gun.Barrel.CFrame.LookVector
	local dot = look:Dot(targetDirection)
	if dot < 0.9 then print("Not yet", dot) return end
	print("FIRE FIRE FIRE FIRE")
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
	print(self.Health)
end

return class
