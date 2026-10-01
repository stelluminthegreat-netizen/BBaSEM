function Preview(self)
    self.Instance.MouseButton1Click:Connect(function()
        local tier = self.ObjParent.Tier
        local type = self.ObjParent.Type

        shared.Placements["T" .. tier][type .. "s"]:noPlotActivate(
            self.ObjParent.ModelName,
            workspace.Bas,
            true,  -- Smart rotation
            false  -- Auto place
        )

        game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
           print(shared.Placements["T" .. tier][type .. "s"]:requestPlacement(game.ReplicatedStorage.Remotes.Events.requestEvent))
        end)
        
        local uiObjs = shared.Classes.UI.Objects
        uiObjs.StructsFrame.ExistingInfo:Close()
        uiObjs.StructsFrame:Close()
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