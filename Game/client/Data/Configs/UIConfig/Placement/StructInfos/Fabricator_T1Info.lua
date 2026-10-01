local config = {
    UIConfig = true,

    Name = "Fabricator_T1Info",
    InstanceName = "StructInfo",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "StructInfo",

    -- Information
    Tier = 1,
    Type = "Fabricator",
    ModelName = "Fabricator_T1",

    Image = "rbxassetid://92073260973532",
    Price = "$10,000",
    Stats = "",

    -- Children related
    ChildrenNames = {
        [1] = "StructPreviewBtn",
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
            Position = UDim2.fromScale(0.76, 0.5)
        },
        Closed = {},
    },

    -- Initializers
    FrameworkFuncs = {},
    GameInit = {
        [1] = "InfoFillUp",
    },
    InitFuncs = {},

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config