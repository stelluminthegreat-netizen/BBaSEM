local self = {}

function self.initialize()
    self.UpdEvent = Instance.new("RemoteEvent")
    self.UpdEvent.Parent = game.ReplicatedStorage.Remotes.Events
    self.UpdEvent.Name = "UpdEconomy"

	self.Cash = 30_000
    self.Income = 0

    self:Mercy()
end

function self:IncrementCash(n: number)
    local check = self.Cash + n
    if check < 0 then return false end
    
    self.Cash += n
    self:Replicate("UpdCash", self.Cash)

    return true
end

function self:UpdateIncome(n: number)
    self.Income += n
    if self.Income <= 0 then self.Income = 0 end
    self:Replicate("UpdIncome", self.Income)
end

function self:Replicate(method: string, ...)
    self.UpdEvent:FireAllClients(method, ...)
end

function self:Mercy()
    shared.Classes.Threads:Spawn(function()
        task.wait(5)    
        self:UpdateIncome(2)
        while task.wait(0.25) do
            self:IncrementCash(2)
        end
    end)
end

return self
