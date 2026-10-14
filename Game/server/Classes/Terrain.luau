local class = {}
class.Objects = {}
class.Terrains = {}
class.Instances = {}
class.__index = class

function class.initialize()
	local regionsHandler = shared.GameClasses.RegionsHandler
	regionsHandler.New:Connect(function(_, region)
		class.Populate(region)
	end)

	BulkAssign()
end

function class.Populate(region)
	local regX, regZ = region.Position.x, region.Position.z
	local size = 50

	for x = regX, regX + size, 10 do
		task.wait()
		for z = regZ, regZ + size, 10 do
			task.wait()
			class.new(x, z)
		end 
	end
end

function class.new(x, z)
	local self = setmetatable({}, class)
	self.Y = GetHeight(x, z)
	self.Position = {["x"] = x, ["z"] = z}
	self.Instance = game.ReplicatedStorage.Map.Terrain.TerrainBlock:Clone()
	self.Instance.Parent = workspace.Map.Terrain
	self.Instance:PivotTo(CFrame.new(x, self.Y, z))
	self.Id = x .. z

	self.Assigned = {}
	if not class.Terrains[x] then class.Terrains[x] = {} end
	class.Terrains[x][z] = self
	class.Objects[self.Id] = self  
	class.Instances[self.Id] = self.Instance

	return self
end

function class:Assign(enemy)
	-- Remove previous terrain
	local prev = enemy.PrevTerrain 
	if prev then enemy.PrevTerrain.Assigned[enemy.Id] = nil end
	if prev == self then return end
	enemy.PrevTerrain = nil

	self.Assigned[enemy.Id] = enemy
	enemy.PrevTerrain = self
	enemy.Y = self.Y

	enemy.Events.Y_Changed:Fire()
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

local SEED = Random.new():NextInteger(1, 2^31 - 1)
local seedRandom = Random.new(SEED)

local seedX = seedRandom:NextNumber(-100000, 100000)
local seedZ = seedRandom:NextNumber(-100000, 100000)

local CELL_SIZE = 1000
local FLAT_THRESHOLD = 0.2
local BLEND_DISTANCE = 30

-- Mountain settings
local MOUNTAIN_SCALE = 350
local MOUNTAIN_THRESHOLD = 0.35
local MOUNTAIN_HEIGHT = 180
local MOUNTAIN_BLEND = 0.3

function GetNormalHeight(x: number, z: number): number
	x += seedX
	z += seedZ

	return 50
		+ math.noise(x / 250, z / 250) * 25
		+ math.noise(x / 100, z / 100) * 10
		+ math.noise(x / 40, z / 40) * 2
end

function GetHeight(x: number, z: number): number
	local cellX = math.floor(x / CELL_SIZE)
	local cellZ = math.floor(z / CELL_SIZE)

	-- Seeded flat-land distribution
	local flatNoise = math.noise(
		cellX / 5 + seedX / 1000,
		cellZ / 5 + seedZ / 1000
	)

	local normalHeight = GetNormalHeight(x, z)
	local height = normalHeight

	-- Flat lands
	if flatNoise > FLAT_THRESHOLD then
		local flatHeight = GetNormalHeight(
			cellX * CELL_SIZE + CELL_SIZE / 2,
			cellZ * CELL_SIZE + CELL_SIZE / 2
		)

		local localX = x - cellX * CELL_SIZE
		local localZ = z - cellZ * CELL_SIZE

		local edgeDistance = math.min(
			localX,
			localZ,
			CELL_SIZE - localX,
			CELL_SIZE - localZ
		)

		local alpha = math.clamp(
			(BLEND_DISTANCE - edgeDistance) / BLEND_DISTANCE,
			0,
			1
		)

		alpha = alpha * alpha * (3 - 2 * alpha)
		height += (flatHeight - height) * (1 - alpha)
	end

	-- Mountain generation
	local mountainNoise = math.noise(
		(x + seedX) / 700 + 1000,
		(z + seedZ) / 700 + 1000
	)

	-- Controls where mountain ranges exist
	local mountainMask = math.clamp(
		(mountainNoise - 0.2) / 0.35,
		0,
		1
	)

	-- Smooth mountain boundaries
	mountainMask = mountainMask * mountainMask
		* (3 - 2 * mountainMask)

	-- Mountain ridges
	local ridgeNoise = math.noise(
		(x + seedX) / 140 + 2000,
		(z + seedZ) / 140 + 2000
	)

	local ridges = 1 - math.abs(ridgeNoise)
	ridges = ridges * ridges

	-- Combine mountain base with ridges
	local mountainHeight = mountainMask
		* (0.35 + ridges * 0.65)
		* MOUNTAIN_HEIGHT

	height += mountainHeight

	return math.floor(height)
end



return class
