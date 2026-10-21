local self = {}

-- Suze Selector
function self.InitSizeBtn(ui)
    ui.Instance.Text = ui.AssignedSize
    ui.DisplayOrder = ui.AssignedSize

    shared.Classes.Threads:Spawn(function()
        ui.Conns.MB1 = ui.Instance.MouseButton1Click:Connect(function()
            task.wait()
            local sizeSelector = shared.Classes.UI.Objects.SizeSelector
            local id = sizeSelector.QueueId
            local queue = shared.GameClasses.Queue.Objects[id]
            local remote = game.ReplicatedStorage.Remotes.Functions.RequestHost
            local success = remote:InvokeServer(id, ui.AssignedSize)
            queue.HostSuccess = success
            sizeSelector:Close()
        end)
    end)
end

return self
