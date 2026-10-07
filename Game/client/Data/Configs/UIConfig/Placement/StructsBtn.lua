function OnClicked(self)
    self.Conns.OnClicked2 = self.Instance.MouseButton1Click:Connect(function()
        task.wait()

        local StructsFrame = shared.Classes.UI.Objects.StructsFrame
        local existingInfo
        if StructsFrame then existingInfo = StructsFrame.ExistingInfo end 
        if existingInfo then existingInfo:Close() return end
        local newInfo = shared.Classes.UI.new("MG_001Info")
        StructsFrame.ExistingInfo = newInfo
    end)
end

local config = {
    UIConfig = true,

    Name = "StructsBtn",
    InstanceName = "StructsBtn",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "StructsBtn",

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
            Position = UDim2.fromScale(0.15, 0.6)
        },
        Closed = {
            Position = UDim2.fromScale(-0.5, -0.5)
        },
    },

    -- Initializers
    FrameworkFuncs = {
        "OpenUIsListener",
        "CloseUIsListener"
    },
    GameInit = {},
    InitFuncs = {
        [1] = OnClicked
    },

    -- Target UIs
    ToClose = {
        "StructsFrame",
    },
    ToOpen = {
        "StructsFrame"
    },

    AnimDuration = 0
}

return config