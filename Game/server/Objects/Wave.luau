local MatchmakingService = game:GetService("MatchmakingService")
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
                Rarity = 7
            },
            Destroyer_001 = {
                Cost = 4,
                Rarity = 3
            },
            Tank_001 = {
                Cost = 5,
                Rarity = 2
            },
        },
        [2] = {
            AbnormalZombie_001 = {
                Cost = 3,
                Rarity = 5
            },
            Destroyer = {
                Cost = 3,
                Rarity = 2
            }
        },
        [3] = {
            Mutant = {
                Cost = 4,
                Rarity = 5
            },
            Intelligent = {
                Cost = 3,
                Rarity = 1
            },
            Boss = {
                Cost = 3,
                Rarity = 0.5    
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
    task.wait(2)
    while true do
        -- Increment Wave count
        self.WaveCount += 1

        -- Select Wave Type
        self:SelectWaveType()

        -- Calculate Budget
        self:CalcBudget()

        -- Upgrade enemies if eligible
        local upgEligible = self:CheckUpgEligibilty()
        if upgEligible then self:UpgradeEnemies() end

        -- GetAvailable regions
        self.AvailRegions = self:GetAvailRegions()

        -- Spawn random enemies
        self:SelectRandomEnemies()
        self:RandomEnemySpawn()

        -- End wait
        self:CalcEndWait()
        self:EndWaveWait()
    end
end

function self:EndWaveWait()
    local minsDisplay
    local secsDisplay

    local currentSecs = 0
    local currentMins = self.WaitInMins
    if self.WaitInSecs > 0 then currentSecs = self.WaitInSecs end

    minsDisplay = ConvertToDisplayable(currentMins)
    secsDisplay = ConvertToDisplayable(currentSecs)

    warn("CURRENT", currentMins .. " : "  .. currentSecs)

    for min = currentMins, 0, -1 do
        minsDisplay = ConvertToDisplayable(min)
        for sec = currentSecs, 0, -1 do
            secsDisplay = ConvertToDisplayable(sec)
            print(minsDisplay .. " : " .. secsDisplay)
            task.wait(1)
        end
        currentSecs = 59
    end
end

function ConvertToDisplayable(time: number)
    if time < 10 then
        time = "0" .. time
    end

    return tostring(time)
end

function self:CalcEndWait()
    local waitInSecs = math.ceil( 30 * self.WaveTypes[self.WaveType].Difficulty * self.WaveCount ^ 0.7)

    self.WaitInSecs = waitInSecs  % 60 
    self.WaitInMins = math.floor(waitInSecs / 60)
end

function self:RandomEnemySpawn()
    for index, enemy in self.SelectedEnemies do
        -- Get random region
        local _, region = GetRandomEntry(self.AvailRegions)
        local regionLoc = Vector2.new(region.Position.x, region.Position.z)
        local random = math.random

        local randomSelectedLoc = Vector2.new(random(regionLoc.X, regionLoc.X + 50), random(regionLoc.Y, regionLoc.Y + 50))

        -- Spawn enemy in that region
        local ENEMY = shared.GameClasses.Enemy.new(enemy)
        ENEMY:Init(CFrame.new(Vector3.new(randomSelectedLoc.X, 0.1, randomSelectedLoc.Y)))
        ENEMY:Start()

    end

end

function GetRandomEntry(dictionary)
    local entries = {}

    for key, value in dictionary do
        table.insert(entries, {
            key = key,
            value = value
        })
    end

    local entry = entries[math.random(1, #entries)]

    return entry.key, entry.value
end

function self:SelectRandomEnemies()
    table.clear(self.SelectedEnemies)
    while self.Budget > 0 do
        local selected = self:SelectRandomEnemy()
        local info = self.CurrentEnemyTypes[selected]

        self.Budget -= info.Cost
        table.insert(self.SelectedEnemies, selected)
    end
end

function self:SelectRandomEnemy()
    local totalWeight = 0

    for _, info in self.CurrentEnemyTypes do totalWeight += info.Rarity end

    local random = math.random() * totalWeight
    local cum = 0

    for enemy, info in self.CurrentEnemyTypes do
        cum += info.Rarity

        if random <= cum then  return enemy end
    end
end

function self:GetAvailRegions()
    local regionsHandler = shared.GameClasses.RegionsHandler
    local initialOccupied = {}
    local finalOccupied = {}
    local available = {}

    -- Get occupied regions
    for x, zS in regionsHandler.Regions do
        for z, region in zS do
            local isOccupied = next(region.Turret or {}) or next(region.Fabricator or {}) or next(region.Wall or {})
            if isOccupied then
                initialOccupied[x .. z] = region
                finalOccupied[x .. z] = region
                -- region.Instance.BrickColor = BrickColor.Red()
            end
        end
    end

    -- Add nearby regions of occupied regions to occupied regions
    -- To give distance allowance
    for _, region in initialOccupied do
        local surroundings = regionsHandler:GetNearbyRegions(region.Position.x, region.Position.z, 1)
        for x, Zs in surroundings do
            for z, nearbyRegion in Zs do
                if finalOccupied[x .. z] then continue end
                finalOccupied[x .. z] = nearbyRegion
                -- nearbyRegion.Instance.BrickColor = BrickColor.Yellow()
            end
        end
    end

    -- Get unoccupied regions near regions in occupied list
    for _, region in finalOccupied do
        local nearbyRegions = regionsHandler:GetNearbyRegions(region.Position.x, region.Position.z, 1)
        for x, zS in nearbyRegions do
            for z, nearbyRegion in zS do
                -- Skip if region is occupied
                if finalOccupied[x .. z] then continue end
                if available[x .. z] then continue end

                available[x .. z] = nearbyRegion
                -- nearbyRegion.Instance.BrickColor = BrickColor.Green()
            end
        end
    end

    return available
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
