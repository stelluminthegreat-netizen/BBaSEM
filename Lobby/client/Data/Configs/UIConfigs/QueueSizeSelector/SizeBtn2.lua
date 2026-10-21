
local config = {
    UIConfig = true,

    AssignedSize = 2,

    Name = "SizeBtn1",
    InstanceName = "SizeBtn",
    InstanceParentName = "SizeSelector",
    UIGroup = "SizeBtn",

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
            Position = UDim2.fromScale(0, 0)
        },
        Closed = {
            Position = UDim2.fromScale(0, -1)
        },
    },

    -- Initializers
    FrameworkFuncs = {},
    GameInit = {
        [1] = "InitSizeBtn"
    },
    InitFuncs = {},

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config