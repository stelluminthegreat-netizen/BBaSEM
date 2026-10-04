function TerminatePlacementListener(self)
    self.Conns.Clicked = self.Instance.MouseButton1Click:Connect(function()
        -- Terminate placement
        self.Placement:terminate()
        self.Placement = nil
        -- Open Structs Btn
        shared.Classes.UI.new("StructsBtn")

        -- Close Buy & Cancel Btn
        shared.Classes.UI.Objects.StructBuyBtn:Close()
        shared.Classes.UI.Objects.StructCancelBtn:Close()
    end)
end

local config = {
    UIConfig = true,

    Name = "StructCancelBtn",
    InstanceName = "StructCancelBtn",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "StructCancelBtn",

    -- Children related
    ChildrenNames = {},
    Children = {},

    -- Event related
    EventNames = {},
    Events = {},
    Conns = {},

    -- State
    Status = {},

    -- Delays
    Delays = {
        Open = 0,
        Close = 0,
    },

    -- Changes
    Changes = {
        Opened = {
            Position = UDim2.fromScale(0.15, 0.732)
        },
        Closed = {
            Position = UDim2.fromScale(0, -1)
        },
    },

    -- Initializers
    FrameworkFuncs = {},
    GameInit = {},
    InitFuncs = {
        [1] = TerminatePlacementListener
    },

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config