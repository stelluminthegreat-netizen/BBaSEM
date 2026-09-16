-- There will be two types of targeting
-- 1. Limited: The range is small
-- 2. Unli: If there is no target within the small range, randomly find a target from a list


local class = {}
class.__index = class

class.Objects = {}
class.EnemyInstances = {}
class.Moving = {}
class.Idling = {}
local enemyCount = 0

local configs = game.ServerScriptService.S_Server.Data.EnemyConfig
local newEvent = game.ReplicatedStorage.Remotes.Events.NewEnemy
local actionEvent = game.ReplicatedStorage.Remotes.Events.EnemyActions

local RegionHandler 
shared.Classes.Threads:Spawn(function()
	while not RegionHandler do
		task.wait()
		RegionHandler = shared.GameClasses.RegionsHandler
	end
end)

function class.initialize()
	BulkMoving()
	BulkIdling()
end

function class.new(type: string)
	enemyCount += 1

	local self = setmetatable(shared.Libraries.Table.DeepClone(require(configs[type])), class)
	self.Instance = game.ReplicatedStorage.ToClone.Server.Enemies[type]:Clone()
	self.Id = type .. tostring(enemyCount)
	self.Instance:SetAttribute("Id", self.Id)
	self.Type = type
	self.Class = "Enemy"
	class.Objects[self.Id] = self
	table.insert(class.EnemyInstances, self.Instance)

	return self
end

function class:Init(pivot: CFrame)
	newEvent:FireAllClients(self.Id, self.Type, pivot)

	shared.Entities[self.Id] = self
	self.Instance.Parent = workspace.Camera
	self:InitEvents()
	
	self.Instance:PivotTo(pivot)
	self:CalcNextPos()
	self:CalcDirection()
end

function class:InitEvents()
	for _, name in self.EventNames do
		local event = shared.Classes.Event.new()
		self.Events[name] = event
	end
end




function class:Start()
	self:StopMove()
end

------------------------ MOVEMENT SYSTEM

function class:Move()
	if class.Moving[self.Id] then return end
	class.Idling[self.Id] = nil
	class.Moving[self.Id] = self
	
	actionEvent:FireAllClients(self.Id, "Move", self.Direction)
end

function class:StopMove()
	if class.Idling[self.Id] then return end
	actionEvent:FireAllClients(self.Id, "StopMove")
	class.Moving[self.Id] = nil
	class.Idling[self.Id] = self
end

function class:CalcNextPos()
	local pivot = self.Instance:GetPivot()
	self.NextPos = pivot.Position + pivot.LookVector * self.WalkSpeed
end

function class:CalcDirection()
	-- Terminate if there is no target
	if not self.Target then return end
	-- Terminate if target did not move
	local targetPivot = self.Target.Instance:GetPivot()
	local samePos = self.PreviousTargetPos == targetPivot.Position
	if self.PreviousTargetPos and samePos then return end

	self.PreviousTargetPos = targetPivot.Position 
	local direction = targetPivot.Position - self.NextPos
	direction = Vector3.new(direction.X, 0, direction.Z)

	self.Direction = direction.Unit
end

function class:DetectObstacle()
	local pivot = self.Instance:GetPivot()

	local origin = pivot.Position
	local direction = pivot.LookVector * 3

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = class.EnemyInstances

	local result = workspace:Raycast(origin, direction, params)
	if not result then
		self:Move()
		return
	end
	if result.Instance.Name == "Baseplate" then return end
	-- Set obstacle as target if it is targetable
	local model = shared.Libraries.Find.FindFirstAncestorWithTag(result.Instance, "Object")
	if model then
		local class = model:GetAttribute("Class")
		local id = model:GetAttribute("Id")
		local object = shared.GameClasses[class].Objects[id]
		self:TargetLock(object)
	end

	self:StopMove()
end

------------------------ TARGET SYSTEM

function class:FindTarget()
	if self.Target then return end
	self:StopMove()
	-- Limited: Find a target in normal range
	local pivot = self.Instance:GetPivot()
	local x, z = pivot.X, pivot.Z
	local result = RegionHandler:Get(x, z, "Target", 1)
	local inRange = {}

	for _, tbl in result do
		for _, item in tbl do
			table.insert(inRange, item)
		end
	end

	for _, entity in inRange do
		if not entity then continue end
		if not self.PrevTargDist then self.PrevTargDist = 0 end
		if entity.Instance.Parent ~= workspace then continue end

		local distance = entity.Instance:GetPivot().Position - pivot.Position
		local x, z = distance.X, distance.Z
		local hypo = math.sqrt(x * x + z * z)
		if hypo > self.PrevTargDist then continue end

		self.PrevTargDist = hypo
		self:TargetLock(entity)
	end

	-- Unli: If no target is within the normal range, ignore limit and find target
	if self.Target then return end
	-- self:StopMove()

	-- When proper character and structure systems are set up, depricate then spatial query
	-- Instead of spatial query, we will randomly choose between character or structure
	-- if structure is chosen, get the list of all existing structures
	-- Randomly select from any of them -- Find the targetables in TargetManager object
	-- Target lock the randomly selected structure
	-- Same goes if character was chosen

	local inRange = shared.Entities
	for _, entity in inRange do
		if not entity.Instance:HasTag("Structure") and not entity.Instance:HasTag("Character") then continue end
		if entity.Instance.Parent ~= workspace then continue end
		self:TargetLock(entity)
		local distance = entity.Instance:GetPivot().Position - pivot.Position
		local x, z = distance.X, distance.Z
		local hypo = math.sqrt(x * x + z * z)
		self.PrevTargDist = hypo
		return
	end
end

function class:TargetLock(target: object)
	self.Target = target
	self:CalcNextPos()
	self:CalcDirection()
	self:MonitorTarget()
	self:Move()
end

function class:TargetDestroyed()
	if not self.Called then self.Called = 0 end
	self.Called += 1
	if self.Called >= 50 then return end
	self.Target = nil
	self:StopMove()
end

function class:MonitorTarget()
	if not self.Target then return end
	if self.Target.Instance.Parent ~= workspace then return end
	if self.PrevTargId == self.Target.Id then return end
	self.PrevTargId = self.Target.Id

	if self.Conns.MonitorTarg then self.Conns["MonitorTarg"]:Disconnect() end
	self.Conns["MonitorTarg"] = self.Target.Events.Died:Connect(function()
		self:TargetDestroyed()
		self.Conns["MonitorTarg"]:Disconnect()
	end)
end

------------------------ ATTACK SYSTEM
function class:Attack()
	-- Debounce if an attack is in progress
	if self.State.Attacking == true then return end
	self.State.Attacking = true
	
	-- Inform client to play attack anim

	-- Delay to match hit 
	task.wait(self.HitDelay)
	self:ActualAttack()
	-- Wait for the remainder of the animation
	task.wait(self.RemainingDelay)

	-- Wait based on Attack Spd
	-- Set attacking to false
	task.wait(self.AttackSpd)
	if not self.State then return end
	self.State.Attacking = false
end

function class:ActualAttack()
		actionEvent:FireAllClients(self.Id, "Attack")
		table.clear(self.InAttRange)

		-- Hitbox
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = class.EnemyInstances

		local pivot = self.Instance:GetPivot()
		local hitBoxPos = pivot.Position + pivot.LookVector * 2
		local inRange = workspace:GetPartBoundsInBox(CFrame.new(hitBoxPos), self.Hitbox, params)
		if #inRange == 0 then self:Move() return end
		-- Scan and store possible targets
		for _, item in inRange do
			-- Filter non-targetable
			local model = shared.Libraries.Find.FindFirstAncestorWithTag(item, "Object")
			if not model then continue end

			local id = model:GetAttribute("Id")
			if self.InAttRange[id] then continue end
			local class = model:GetAttribute("Class")
			local object = shared.GameClasses[class].Objects[id]
			self.InAttRange[id] = object
		end

		-- Apply damage
		for id, target in self.InAttRange do
			target:IncrementHealth(-self.Dmg)
			self.InAttRange[id] = nil
		end

end

------------------------ SELF
function class:IncrementHealth(n: number)
	if not self then return end
	if not self.Health then return end
	self.Health += n
	if self.Health <= 0 then self:Die() end
	actionEvent:FireAllClients(self.Id, "IncrementHealth", nil, self.Health)
end

function class:Die()
	-- Do death stuff like animations 
	actionEvent:FireAllClients(self.Id, "Destroy")

	shared.Entities[self.Id] = nil

	class.Objects[self.Id] = nil
	class.EnemyInstances[self.Id] = nil
	class.Moving[self.Id] = nil
	class.Idling[self.Id] = nil

	local x, z = self.PreviousCoords.x, self.PreviousCoords.z
	shared.GameClasses.RegionsHandler:Remove(x, z, self, "Enemy")

	for _, child in self.Instance:GetChildren() do
		if not child:IsA("BasePart") then continue end
		shared.Classes.Threads:Spawn(function()
			while child.Transparency ~= 1 do
				child.Transparency += 0.1
				task.wait(0.1)
			end
		end)
	end
	self.Target = nil

	self.Events.Died:Fire()
	self:Destroy()
end

function class:Destroy()
	for name, conn in self.Conns do conn:Disconnect() self.Conns[name] = nil end
	for name, _ in self.Events do self.Events[name] = nil end
	
	self.Instance:Destroy()
	shared.Libraries.Table.DeepClean(self)
end

------------------------ BULKS
local cont = true

-- Sets the Pivot of all Enemies per tick
function BulkMoving()
	shared.Classes.Task.OnTick:Connect(function()
		if cont ~= true then return end
		cont = false
		shared.Classes.Task:Wait(48 / 24)
		cont = true
		for _, enemy in class.Moving do
			-- Terminate if list is empty
			if not enemy then return end
			
			enemy:DetectObstacle()
			enemy:CalcNextPos()
			enemy:CalcDirection()
			enemy.Instance:PivotTo(CFrame.lookAt(enemy.NextPos, enemy.NextPos + enemy.Direction))
		end
	end)
end

function BulkIdling()
	shared.Classes.Task.OnTick:Connect(function()
		if cont ~= true then return end
		for _, enemy in class.Idling do
			-- Terminate if list is empty
			if not enemy then return end
			-- Terminate if enemy NextPos/Direction has not yet been calculated
			
			if enemy.Target then enemy:Attack() end
			enemy:FindTarget()
		end
	end)
end


return class
