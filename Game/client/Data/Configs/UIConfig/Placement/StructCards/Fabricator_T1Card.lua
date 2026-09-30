local config = {
    UIConfig = true,

    Name = "Fabricator_T1",
    InstanceName = "StructCard",
    InstanceParentName = "StructsFrame",
    UIGroup = "StructsFrame",

    Image = "rbxassetid://92073260973532",
    UI_InfoName = "Fabricator_T1Info",


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
        [2] = "CardOnClicked",
    },
    InitFuncs = {},

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config