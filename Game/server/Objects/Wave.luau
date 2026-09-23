local ServerScriptService = game:GetService("ServerScriptService")
local NormalZombie = require(ServerScriptService.S_Server.Data.EnemyConfig.NormalZombie)
local self = {}

function self.initialize()
    -- WAVE RELATED
	self.WaveCount = 0
    self.Budget = 0
    self.EndWait = 0
    self.StartWait = 30
    self.Cleared = false
    self.WaveTypes = {
        Recovery = {
            Difficulty = 0.7,
            Rarity = 0
        },
        Normal = {
            Difficulty = 1.4,
            Rarity = 0.6
        },
        Hard = {
            Difficulty = 1.7,
            Rarity = 0.4
        },
        Crisis = {
            Difficulty = 2.5,
            Rarity = 0.1
        },
    }
    self.WaitInSecs = 0
    self.WaitInMins = 0

    -- ENEMY RELATED
    self.EnemyLevels = {
        [1] = {
            NormalZombie_001 = {
                Cost = 2,
                Rarity = 0.5
            }
        },
        [2] = {
            AbnormalZombie_001 = {
                Cost = 3,
                Rarity = 0.5
            },
            Destroyer = {
                Cost = 3,
                Rarity = 0.2
            }
        },
        [3] = {
            Mutant = {
                Cost = 4,
                Rarity = 0.5
            },
            Intelligent = {
                Cost = 3,
                Rarity = 0.2
            }
        }
    }
    self.EnemyTypes = self.EnemyLevels[1]
    self.CurrentEnemyTypes = {}
    self.UpgradeCheckpoints = {
        [1] = true,
        [25] = true,
        [30] = true
    }
    self.SelectedEnemies = {}
    self.CurentLevel = 0

    -- ETC
    self.AvailRegions = {}

end

function self.start()
    while task.wait(0.1) do
        -- Increment Wave count
        self.WaveCount += 1

        -- Select Wave Type
        self:SelectWaveType()

        -- Calculate Budget
        self:CalcBudget()

        -- Upgrade enemies if eligible
        local upgEligible = self:CheckUpgEligibilty()
        if upgEligible then self:UpgradeEnemies() end
        print(self.CurrentEnemyTypes, upgEligible)
    end
end

function self:UpgradeEnemies()
    self.CurentLevel += 1
    self.CurrentEnemyTypes = self.EnemyLevels[self.CurentLevel]
end

function self:CheckUpgEligibilty()
    return self.UpgradeCheckpoints[self.WaveCount]
end

function self:CalcBudget()
    local currentWave = self.WaveTypes[self.WaveType]
    self.Budget = math.round((100 + self.WaveCount ^ 1.5)* currentWave.Difficulty)
end

function self:SelectWaveType()
    if self.PreviousWave == "Crisis" then self.WaveType = "Recovery" self.PreviousWave = "" return end
    local randomNum = math.random()

    if randomNum <= 0.6 and randomNum >= 0 then
        -- Normal
        self.WaveType = "Normal"
    elseif randomNum <= 0.9 and randomNum > 0.6 then
        -- Hard
        self.WaveType = "Hard"
    else
        -- Crisis
        self.WaveType = "Crisis"
    end

    self.PreviousWave = self.WaveType
    return
end



return self
