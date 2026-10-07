local self = {}

function self.initialize()
    self.CashUI = game.Players.LocalPlayer.PlayerGui.ConsiderSafeArea.Cash

	local updEvent = game.ReplicatedStorage.Remotes.Events.UpdEconomy
    updEvent.OnClientEvent:Connect(function(method: string, ...)
        self[method](self, ...)
    end)
end

function self:UpdCash(cashVal: number)
    self.Cash = cashVal
    self:UpdUI()
end

function self:UpdIncome(incomeVal: number)
    self.Income = incomeVal
    self:UpdUI()
end

function self:UpdUI()
    local cashText = shared.Libraries.MinorTasksHandler.AddCommasToNums(self.Cash)
    local incomeText = shared.Libraries.MinorTasksHandler.AddCommasToNums(self.Income)
    self.CashUI.Text = "$" .. cashText .. "(+" .. incomeText .. ")"
end

return self
