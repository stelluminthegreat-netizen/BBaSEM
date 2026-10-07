local self = {}
self.Prices = {
    -- T1
    ["Fabricator_T1"] = 8000,
    ["MG_001"] = 5000,
}

function self.initialize()
    local PlacementFunc = Instance.new("RemoteFunction")
    PlacementFunc.Name = "PlacementFunc"
    PlacementFunc.Parent = game.ReplicatedStorage.Remotes.Functions
    
    PlacementFunc.OnServerInvoke = function(plr, item, _1, prefabs, cf)
        if not ValidatePlacementRequest(item) then return false end
        Place(item, prefabs, cf)



        return true
    end
end

function self.start()
	
end

function ValidatePlacementRequest(item)
    local economy = shared.GameClasses.Economy
    local price = self.Prices[item]
    local canAfford = economy:IncrementCash(-price)

    if not canAfford then return false end
    return true
end

function Place(item, prefabs, cf)
        local struct = shared.GameClasses[prefabs.Name].new(item)
        struct:Init(cf)
        struct:Start()
end

return self
