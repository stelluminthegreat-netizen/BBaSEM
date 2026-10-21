local config = {
    UIConfig = true,

    Name = "SizeSelector",
    InstanceName = "SizeSelector",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "SizeSelector",

    -- Children related
    ChildrenNames = {
        [1] = "SizeBtn1",
        [2] = "SizeBtn2",
        [3] = "SizeBtn3",
        [4] = "SizeBtn4",
    },
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
            Position = UDim2.fromScale(0.5, 0.5)
        },
        Closed = {
            Position = UDim2.fromScale(0, -1)
        },
    },

    -- Initializers
    FrameworkFuncs = {},
    GameInit = {},
    InitFuncs = {},

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config