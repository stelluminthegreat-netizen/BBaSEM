local RunService = game:GetService("RunService")
local self = {}
self.Terrains = {}

self.BlockSize = 10

local event = game.ReplicatedStorage.Remotes.Events.CreateTerrain
local regionsHandler = shared.GameClasses.RegionsHandler
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local loaded = {}
local loadedTerrains = {}

function self.initialize()
	event.OnClientEvent:Connect(function(msg: string, ...)
        print(msg)
        if msg == "bulk" then
            Bulk(...)
        end
    end)
end

function Bulk(terrains: table)
    for _, terrain in terrains do
        RunService.Heartbeat:Wait()
        self:Create(terrain)
    end
end

function self:Create(terrain)
    local x = terrain.x
    local z = terrain.z

    self.Terrains[x .. "_" .. z] = terrain
end

function self:ToggleVisual(terrain, signal: boolean)
    local x = terrain.x
    local y = terrain.y
    local z = terrain.z

    if signal == true then
        local terrainBlock = game.ReplicatedStorage.Map.Terrain.TerrainBlock:Clone()
        terrainBlock.Parent = workspace.Map.Terrain
        terrainBlock:PivotTo(CFrame.new(Vector3.new(x, y, z)))

        terrain.Instance = terrainBlock
        terrain.Instance.Name = terrain.x .. terrain.z
    elseif signal == false then
        terrain.Instance:Destroy()
    end

end

function self:Unload(region)
    -- Remove region from loaded
    loaded[region.x][region.z] = nil

    -- Unload region
    for x = region.x, region.x + 40, 10 do
            -- task.wait()
        for z = region.z, region.z + 40, 10 do
            if not loadedTerrains[x .. "_" .. z] then continue end
            self:ToggleVisual(self.Terrains[x .. "_" .. z], false)
            loadedTerrains[x .. "_" .. z] = nil
        end
    end
end

function self:Load(region)
    -- Insert region into loaded
    if not loaded[region.x] then loaded[region.x] = {} end
    loaded[region.x][region.z] = region

    -- Load region
    for x = region.x, region.x + 40, 10 do
            -- task.wait()
        for z = region.z, region.z + 40, 10 do
            if loadedTerrains[x .. "_" .. z] then continue end
            -- print(x .. "_" .. z)
            self:ToggleVisual(self.Terrains[x .. "_" .. z], true)
            loadedTerrains[x .. "_" .. z] = self.Terrains[x .. "_" .. z]
        end
    end
end

function self.start()

    for i = 0, 5 do
        task.wait(1)
        warn(i)
    end

    while not regionsHandler do
        regionsHandler = shared.GameClasses.RegionsHandler
        task.wait()
    end

    while true do
        -- Pinpoint character position
        local position = char:GetPivot().Position
        local x, z = position.X, position.Z

        -- Get nearby regions
        local regions = regionsHandler:GetNearbyRegions(x, z, 20)

        -- Filter and unload regions
        for x, zS in loaded do
            for z, region in zS do
                -- Skip if loaded region is within new target regions
                if regions[x] and regions[x][z] then continue end
                self:Unload(region)
                task.wait()
            end
        end
        -- Filter and load regions
        for x, zS in regions do
            for z, region in zS do
                -- Skip if region is loaded
                -- region.Instance.BrickColor = BrickColor.Red()
                if loaded[x] and loaded[x][z] then continue end
                self:Load(region)
                task.wait()
            end
        end
        task.wait()
    end
end
return self
