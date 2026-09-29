local config = {
    UIConfig = true,

    Name = "StructsFrame",
    InstanceName = "StructsFrame",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "StructsFrame",

    -- Children related
    ChildrenNames = {
        "MG_001Card",
    },
    Children = {},

    -- Event related
    EventNames = {},
    Events = {},
    Conns = {},

    -- State
    Status = {},

    -- Delays
    Delays = {},

    -- Changes
    Changes = {
        Opened = {
            Position = UDim2.fromScale(0.5, 0.5)
        },
        Closed = {
            Position = UDim2.fromScale(-0.5, -0.5)
        },
    },

    -- Initializers
    FrameworkFuncs = {},
    GameInit = {},
    InitFuncs = {},

    -- Target UIs
    ToClose = { },
    ToOpen = {},

    AnimDuration = 0,
}

return config