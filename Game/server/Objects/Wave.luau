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
        }
    }
    self.EnemyTypes = self.EnemyLevels[1]
    self.CurrentEnemyTypes = {}
    self.UpgradeCheckpoints = {
        [25] = true
    }
    self.SelectedEnemies = {}

    -- ETC
    self.AvailRegions = {}

end

function self.start()
    -- Increment Wave count
    self.WaveCount += 1
    while task.wait(0.5) do
        self:SelectWaveType()
    end
    -- Select Wave Type
end

function self:SelectWaveType()
    if self.PreviousWave == "Crisis" then self.WaveType = "Recovery" self.PreviousWave = "" print(self.WaveType) return end
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
