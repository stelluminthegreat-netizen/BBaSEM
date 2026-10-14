local self = {}
self.Regions = {}
self.SIZE = 50

function self.initialize()
	local remote = game.ReplicatedStorage.Remotes.Events.NewRegion
    remote.OnClientEvent:Connect(function(state: string, ...)
        if state == "existing" then
            ExistingHandler(...) 
        elseif state == "new" then
            NewHandler(...)
        else
            warn("New regions remote received no state", state, ...)
        end
    end)
end

function NewHandler(x: number, z: number)
    if not self.Regions[x] then self.Regions[x] = {} end
    self.Regions[x][z] = {}
end

function ExistingHandler(existing: table)
    for _, coordinates in existing do
        local x = coordinates.x
        local z = coordinates.z
        if not self.Regions[x] then self.Regions[x] = {} end

        self.Regions[x][z] = {}
    end
end

function clamp(x: number, z: number)
    x = math.floor(x / self.SIZE) * self.SIZE
    z = math.floor(z / self.SIZE) * self.SIZE

    return x, z
end

function self.start()
	
end

return self
