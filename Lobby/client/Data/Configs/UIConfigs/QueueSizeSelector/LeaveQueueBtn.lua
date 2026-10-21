function Init(self)
    self.Conns.MB1 = self.Instance.MouseButton1Click:Connect(function()
        local remote = game.ReplicatedStorage.Remotes.Functions.RequestLeave
        remote:InvokeServer(self.QueueId)
        self:Close()
    end)
end

local config = {
    UIConfig = true,

    Name = "LeaveQueueBtn",
    InstanceName = "LeaveQueueBtn",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "LeaveQueueBtn",

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
            Position = UDim2.fromScale(0.5, 0.818)
        },
        Closed = {
            Position = UDim2.fromScale(0, -1)
        },
    },

    -- Initializers
    FrameworkFuncs = {},
    GameInit = { },
    InitFuncs = {
        [1] = Init
    },

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config