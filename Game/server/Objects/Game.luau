local self = {}

function self.initialize()
    game.Players.PlayerAdded:Connect(function(player)
        shared.GameClasses.Character.new(player):Init()
    end)
    for _, plr in game.Players:GetChildren() do
        if shared.GameClasses.Character.Objects[plr.Name] then continue end
        shared.GameClasses.Character.new(plr):Init()
    end
end

function self.start()
end

return self
