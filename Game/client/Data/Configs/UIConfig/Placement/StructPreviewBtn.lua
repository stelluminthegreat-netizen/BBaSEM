function Preview(self)
    self.Conns.MB1 = self.Instance.MouseButton1Click:Connect(function()
        local tier = self.ObjParent.Tier
        local type = self.ObjParent.Type
        -- Open buy and cancel btn
        local buyBtn = shared.Classes.UI.new("StructBuyBtn")
        buyBtn.StructTier = tier
        buyBtn.StructType = type

        local cancelBtn = shared.Classes.UI.new("StructCancelBtn")
        cancelBtn.Placement = shared.Placements["T" .. tier][type]

        print("T" .. tier, type, shared.Placements["T" .. tier][type], shared.Placements)

        shared.Placements["T" .. tier][type]:noPlotActivate(
            self.ObjParent.ModelName,
            workspace,
            true,  -- Smart rotation
            false  -- Auto place
        )

        local uiObjs = shared.Classes.UI.Objects
        uiObjs.StructsFrame.ExistingInfo:Close()
        uiObjs.StructsFrame:Close()
        uiObjs.StructsBtn:Close()
    end)
end

local config = {
    UIConfig = true,

    Name = "StructPreviewBtn",
    InstanceName = "StructPreviewBtn",
    InstanceParentName = "Information",
    UIGroup = "StructInfo",

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
    InitFuncs = {
        [1] = Preview,
    },
    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config