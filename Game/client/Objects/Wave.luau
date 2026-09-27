local self = {}
local updateEvent = game.ReplicatedStorage.Remotes.Events.UpdWaveUI
self.StateUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("IgnoreSafeArea").WaveState
self.TypeUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("IgnoreSafeArea").WaveType

function self.initialize()
	updateEvent.OnClientEvent:Connect(function(name: string, content: string)
        self:UpdUI(name, content, type)
    end)
end
 
function self:UpdUI(ui: string, content: string)
    self[ui].Text = content
end

return self
