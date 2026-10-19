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
    self.Regions[x][z] = {['x'] = x, ['z'] = z}
    self.Regions[x][z].Id = x .. "_" .. z

    self:Visualize(self.Regions[x][z])
end

function ExistingHandler(existing: table)
    for _, coordinates in existing do
        local x = coordinates.x
        local z = coordinates.z
        if not self.Regions[x] then self.Regions[x] = {} end

        self.Regions[x][z] = {['x'] = x, ['z'] = z}
        self.Regions[x][z].Id = x .. "_" .. z
        self:Visualize(self.Regions[x][z])
    end
end

function clamp(x: number, z: number)
    x = math.floor(x / self.SIZE) * self.SIZE
    z = math.floor(z / self.SIZE) * self.SIZE

    return x, z
end

function self:GetNearbyRegions(x: number, z: number, radius: number)
    x, z = clamp(x, z)
    local vals = {0}
    local nearby = {}
    local n = 0 -- Negative value
    local p = 0 -- Positive value

    for i = 1, radius do
        p += self.SIZE
        n -= self.SIZE

        table.insert(vals, p)
        table.insert(vals, n)
    end

    for _, xVal in vals do
        for _, zVal in vals do
            local xReg = self.Regions[x + xVal]
            if not xReg then continue end
            local zReg = self.Regions[x + xVal][z + zVal]
            if not zReg then continue end
            if not nearby[x + xVal] then nearby[x + xVal] = {} end
            nearby[x + xVal][z + zVal] = zReg
        end
    end

    return nearby
end


function self:Visualize(region)
    -- local part = Instance.new("Part", workspace)
    -- part.Transparency = 0.8
    -- part.Position = Vector3.new(region.x + 25, 0, region.z + 25)
    -- part.Size = Vector3.new(self.SIZE, 125, self.SIZE)
    
    -- part.CanCollide = false
    -- part.CanQuery = false
    -- part.CanTouch = false
    -- part.Anchored = true

    -- region.Instance = part
end

function self.start()
end

return self
