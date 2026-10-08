local config = {
    UIConfig = true,

    Name = "SelfReviveBtn",
    InstanceName = "SelfReviveBtn",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "SelfReviveBtn",

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
            Position = UDim2.fromScale(0.5, 0.6)
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