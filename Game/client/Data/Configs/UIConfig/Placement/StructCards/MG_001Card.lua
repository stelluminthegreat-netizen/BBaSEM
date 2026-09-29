local config = {
    UIConfig = true,

    Name = "MG_001",
    InstanceName = "StructCard",
    InstanceParentName = "StructsFrame",
    UIGroup = "StructsFrame",

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
        Opened = {},
        Closed = {},
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