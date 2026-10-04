function PlacementListener(self)
    local UIS = game:GetService("UserInputService")
    shared.Classes.Threads:Spawn(function()
        while not self.StructTier and not self.StructType do
            task.wait()
        end  
              
        local remoteFunc = game.ReplicatedStorage.Remotes.Functions.PlacementFunc
        local placement = shared.Placements["T" .. self.StructTier][self.StructType] 

        -- Listen to button click if mobile
        if UIS.TouchEnabled then 
            self.Conns.Mouse1Down = self.Instance.MouseButton1Click:Connect(function()
                placement:requestPlacement(remoteFunc)
            end)
            return
        end

        -- Listen to mouse down if PC
        local mouse = game.Players.LocalPlayer:GetMouse()

        self.Conns.Mouse1Down = mouse.Button1Down:Connect(function()
            placement:requestPlacement(remoteFunc)
        end)
    end)


end

local config = {
    UIConfig = true,

    Name = "StructBuyBtn",
    InstanceName = "StructBuyBtn",
    InstanceParentName = "IgnoreSafeArea",
    UIGroup = "StructBuyBtn",

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
            Position = UDim2.fromScale(0, -1)
        },
    },

    -- Initializers
    FrameworkFuncs = {},
    GameInit = {},
    InitFuncs = {
        [1] = PlacementListener
    },

    -- Target UIs
    ToClose = {},
    ToOpen = {},

    AnimDuration = 0
}

return config