local self = {}

function self.initialize()

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

function self.start()
	
end

return self
