local self = {}
self.Regions = {}
self.SIZE = 50
self.PossibleVals = {50, -50, 0}

function self.initialize()
	self:Create(0, 0)
    while true do
        task.wait(1)
        self:Expand()
    end
end

function self.start()
	
end

function self:Create(x: number, z: number)
    -- Create x axis if not yet created
    if not self.Regions[x] then self.Regions[x] = {} end
    self.Regions[x][z] = {
        Position = {["z"] = z, ["x"] = x},
        Objects = {},
    }
    self:Visualize(self.Regions[x][z])
end

function self:Expand()
    local temporaryList = {}
    for x, z in self.Regions do
        for z, region in z do
            temporaryList[tostring(x) .. tostring(z)] = region
        end
    end
    for _, region in temporaryList do
        local x = region.Position.x
        local z = region.Position.z

        local availableSpaces = self:GetAvailableSpaces(x, z)
        for _, positions in availableSpaces do
            local availableX = positions.x
            local availableZ = positions.z

            self:Create(availableX, availableZ)
        end
    end
end

function self:GetAvailableSpaces(x: number, z: number)
    local availableSpaces = {}
    local count = 1 
    for _, xVal in self.PossibleVals do
        for _, zVal in self.PossibleVals do
            local targetX = x + xVal
            local targetZ = z + zVal
            if self.Regions[targetX] and self.Regions[targetX][targetZ] then continue end
            availableSpaces[count] = {["x"] = targetX, ["z"] = targetZ}
            count += 1
        end
    end

    return availableSpaces
end

function self:Insert()
    
end

function self:Visualize(region)
    local part = Instance.new("Part", workspace)
    part.Anchored = true
    part.Transparency = 0.7
    part.Position = Vector3.new(region.Position.x, 0, region.Position.z)
    part.Size = Vector3.new(self.SIZE, self.SIZE, self.SIZE)
end

return self
