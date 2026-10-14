local RunService = game:GetService("RunService")
local self = {}
self.Terrains = {}
self.BlockSize = 10
local event = game.ReplicatedStorage.Remotes.Events.CreateTerrain

function self.initialize()
	event.OnClientEvent:Connect(function(msg: string, ...)
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

    self.Terrains[x .. z] = terrain
end

function self:Visualize(terrain)
    local x = terrain.x
    local y = terrain.y
    local z = terrain.z

    local terrainBlock = game.ReplicatedStorage.Map.Terrain.TerrainBlock:Clone()
    terrainBlock.Parent = workspace.Map.Terrain
    terrainBlock:PivotTo(CFrame.new(Vector3.new(x, y, z)))
end
return self
