local self = {}
self.Regions = {}
self.GLOBAL = {}
self.SIZE = 50
self.PossibleVals = {50, -50, 0}

function self.initialize()
    shared.Classes.Threads:Spawn(function()
        self:Create(0, 0)
        local count = 0
        while true do
            count += 1
            task.wait(0.5)
            self:Expand()
            if count == 10 then break end
        end
    end)
end

function self.start()
	shared.Classes.Task.OnTick:Connect(function()
        for _, descendant in game.Workspace:GetDescendants() do
            if not descendant:IsA("Model") then continue end
            if not descendant:HasTag("Object") then continue end
            local class = descendant:GetAttribute("Class")
            local id = descendant:GetAttribute("Id")
            -- if not self.GLOBAL[class] then self.GLOBAL[class] = {} end
            if self.GLOBAL[id] then continue end
            self.GLOBAL[id] = descendant
        end

        for _, object in self.GLOBAL do
            local position = object:GetPivot().Position
            local x, z = clamp(position.X, position.Z)

            local PreviousCoords = object:GetAttribute("PreviousCoords")
            if PreviousCoords then
                local prevX, prevZ = clamp(PreviousCoords.X, PreviousCoords.Y)

                -- Remove from previous region if current position is not equal to previous position
                if x ~= prevX or z ~= prevZ then 
                    self:Remove(prevX, prevZ, object, object:GetAttribute("Class"))
                end
            end

            local existing = self:Insert(x, z, object, object:GetAttribute("Class"))
            if existing == true then continue end 

            object:SetAttribute("PreviousCoords", Vector2.new(x, z))
        end
    end)
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

function self:Insert(x: number, z:number, model: Model, class: string)
    x = math.floor(x / self.SIZE) * self.SIZE
    z = math.floor(z / self.SIZE) * self.SIZE
    if not self.Regions[x][z][class] then self.Regions[x][z][class] = {} end
    if self.Regions[x][z][class][model:GetAttribute("Id")] then return true end
    self.Regions[x][z][class][model:GetAttribute("Id")] = model   
    warn(model.Name .. " is in region " .. x .. " / " .. z)
end

function self:Remove(x: number, z:number, model: Model, class: string)
    x = math.floor(x / self.SIZE) * self.SIZE
    z = math.floor(z / self.SIZE) * self.SIZE
    print("Removing from prev location", self.Regions[x][z].Position,self.Regions[x][z][class])
    self.Regions[x][z][class][model:GetAttribute("Id")] = nil   
    print("Removed from prev location", self.Regions[x][z].Position, self.Regions[x][z][class])
end

function self:Get(x: number, z: number, class: string, includeSurroundings: boolean)
    x, z = clamp(x, z)
    if includeSurroundings == true then
        local surroundingContents = {}

        for _, xVal in self.PossibleVals do
            for _, zVal in self.PossibleVals do
                local xReg = self.Regions[x + xVal]
                if not xReg then continue end
                local zReg = self.Regions[x + xVal][z + zVal]
                if not zReg then continue end
                print(zReg)
                table.insert(surroundingContents, zReg[class])
            end
        end

        return surroundingContents
    end

    print("Searching: ", self.Regions[x][z])
    return self.Regions[x][z][class]
end

function self:Visualize(region)
    local part = Instance.new("Part", workspace)
    part.Anchored = true
    part.Transparency = 0.8
    part.Position = Vector3.new(region.Position.x + 25, 0, region.Position.z + 25)
    part.Size = Vector3.new(self.SIZE, self.SIZE, self.SIZE)
end

function clamp(x: number, z: number)
    x = math.floor(x / self.SIZE) * self.SIZE
    z = math.floor(z / self.SIZE) * self.SIZE

    return x, z
end

return self
