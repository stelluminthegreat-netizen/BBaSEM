local config = {
    UIConfig = true,

    Name = "SingleBarrelMg",
    InstanceName = "StructCard",
    InstanceParentName = "StructsFrame",
    UIGroup = "StructsFrame",

    Image = "rbxassetid://6846488809",
    UI_InfoName = "SingleBarrelMgInfo",

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
    GameInit = {
        [1] = "CardFillUp",
        [2] = "CardOnClicked"
    },
    InitFuncs = {},

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config