local self = {}
self.BlockSize = 10
local event = game.ReplicatedStorage.Remotes.Events.CreateTerrain

function self.initialize()
	event.OnClientEvent:Connect(function(msg: string, ...)
        if msg == "new" then
            New(...)
        elseif msg == "existing" then
            Existing(...)
        end
    end)
end

function New(x: number, y: number, z: number)
    local terrain = game.ReplicatedStorage.Map.Terrain.TerrainBlock:Clone()
    terrain.Parent = workspace.Map.Terrain
    terrain:PivotTo(CFrame.new(Vector3.new(x, y, z)))
end

function Existing(x: number, y: number, z: number)
    print(x, y, z)
    local terrain = game.ReplicatedStorage.Map.Terrain.TerrainBlock:Clone()
    terrain.Parent = workspace.Map.Terrain
    terrain:PivotTo(CFrame.new(Vector3.new(x, y, z)))
end

function self.start()
	
end

return self
