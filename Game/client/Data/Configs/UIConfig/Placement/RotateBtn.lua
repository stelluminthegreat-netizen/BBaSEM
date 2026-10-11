function MB1(self)
    self.Conns.MB1 = self.Instance.MouseButton1Click:Connect(function()
        print(self.Placement)
        self.Placement:rotate()
    end)
end

local config = {
    UIConfig = true,

    Name = "RotateBtn",
    InstanceName = "RotateBtn",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "RotateBtn",

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
            Position = UDim2.fromScale(0.091, 0.414)
        },
        Closed = {
            Position = UDim2.fromScale(0, -1)
        },
    },

    -- Initializers
    FrameworkFuncs = {},
    GameInit = {},
    InitFuncs = {
        [1] = MB1
    },

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config