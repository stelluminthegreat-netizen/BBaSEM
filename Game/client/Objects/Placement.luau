local self = {}

shared.Placements = {}

function self.initialize()
	self.StructsFolder = game.ReplicatedStorage.ToClone.Client.Structures:GetChildren()
end

function self.start()
	for _, tier in self.StructsFolder do
        for _, type in tier:GetChildren() do
            local placement = shared.Libraries.Placement.new(
            1, -- Grid size
            type,

            Enum.KeyCode.R, -- Rotate
            Enum.KeyCode.X, -- Cancel
            Enum.KeyCode.U, -- Raise
            Enum.KeyCode.L, -- Lower

            Enum.KeyCode.ButtonR1,
            Enum.KeyCode.ButtonX,
            Enum.KeyCode.DPadUp,
            Enum.KeyCode.DPadDown
        )
        if not shared.Placements[tier.Name] then shared.Placements[tier.Name] = {} end
        shared.Placements[tier.Name][type.Name] = placement

        print(shared.Placements)
        end
    end
end

return self
