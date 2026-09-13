local class = {}
class.Objects = {}
class.IsReady = {}
class.__index = class

local configs = script.Parent.Parent.Data.FabricatorConfig
local count = 0

function class.initialize()
	BulkGenerate()
end

function class.new(TYPE: string)
	count += 1

	local self = setmetatable(shared.Libraries.Table.DeepClone(require(configs[TYPE])), class)
	self.Instance = game.ReplicatedStorage.ToClone.Server.Fabricators[TYPE]:Clone()
	self.Id = TYPE .. "_" .. count
	self.Instance:SetAttribute("Id", self.Id)
	return self
end

function class:Init(pos: Vector3)
	self:InitEvents()
	shared.Entities[self.Id] = self
	class.Objects[self.Id] = self


	self.Instance.Parent = workspace
	self.Instance:PivotTo(self.Instance:GetPivot() - self.Instance:GetPivot().Position + pos)
end

function class:InitEvents()
	for _, name in self.EventNames do
		local event = shared.Classes.Event.new()
		self.Events[name] = event
	end
end

function class:Start()
	class.IsReady[self.Id] = self
end

function class:Generate()
	shared.Classes.Threads:Spawn(function()
		class.IsReady[self.Id] = nil
		shared.GameClasses.Economy:IncrementCash(self.GenerationRate)
		task.wait(self.GenerationInterval)
		if not class.IsReady[self.Id] then return end
		class.IsReady[self.Id] = self
	end)
end

function class:IncrementHealth(n: number)
	if not self or not self.Health then return end
	self.Health += n
	if self.Health > 0 then return end
	self:Die()
end

function class:Die()
	-- Do death stuff like animations 
	shared.Entities[self.Id] = nil

	class.Objects[self.Id] = nil
	class.IsReady[self.Id] = nil

	local x, z = self.PreviousCoords.x, self.PreviousCoords.z
	shared.GameClasses.RegionsHandler:Remove(x, z, self, "Fabricator")

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

	self.Events.Destroyed:Fire()
	self:Destroy()
end

function class:Destroy()
	self.Instance:Destroy()

	for name, conn in self.Conns do conn:Disconnect() self.Conns[name] = nil end
	for name, _ in self.Events do self.Events[name] = nil end
	
	self.Instance:Destroy()
	shared.Libraries.Table.DeepClean(self)
end

function BulkGenerate()
	shared.Classes.Task.OnTick:Connect(function()
		for _, fabricator in class.IsReady do
			fabricator:Generate()
		end
	end)
end

return class
