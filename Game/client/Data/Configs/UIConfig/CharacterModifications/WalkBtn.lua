function OnClick(self)
    self.Conns.MB1_2 = self.Instance.MouseButton1Click:Connect(function()
        task.wait()
        shared.Classes.UI.new("RunBtn")
        self:Close()
    end)
end

local config = {
    UIConfig = true,

    Input = "LeftControl_Ended",

    Name = "WalkBtn",
    InstanceName = "WalkBtn",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "WalkBtn",

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
            Position = UDim2.fromScale(0.901, 0.499)
        },
        Closed = {
            Position = UDim2.fromScale(0, -1)
        },
    },

    -- Initializers
    FrameworkFuncs = {},
    GameInit = {
        [1] = "MobilePlayerInput"
    },
    InitFuncs = {
        OnClick
    },

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config