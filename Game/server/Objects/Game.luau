local RegionsHandler = require(script.Parent.RegionsHandler)
local self = {}

function self.initialize()
	
end

function random()
    return math.random(-110, 150)
end

function self.start()
    -- task.wait(1)
    -- -- game.Players.PlayerAdded:Wait()
    -- -- task.wait(3)
    -- print("Added")
    -- -- task.wait(2)
    -- print("Starting")
    local num = 0
    local turretStart = 0
    -- local enemyStart = 0
    -- task.spawn(function()
    --    while true do
    --     enemyStart += 1
    --     if enemyStart == 21 then break end
    --     local pivot = CFrame.new(Vector3.new(random(), 0, random()))
    --     local enemy = shared.GameClasses.Enemy.new("NormalZombie")
    --     enemy:Init(pivot)
    --     enemy:Start()
    --     -- task.wait(0.01)
    --     print(enemyStart)
    --    end
    -- end)
    -- task.wait(1)
    task.spawn(function()
        while num ~= 2 do
            num += 1

            turretStart += 5
            local turret = shared.GameClasses.Turret.new("MG_001")
            turret:Init(Vector3.new(turretStart, 0.1, turretStart))
            turret:Start()

            task.wait(2)
        end
    end)

    -- local num = 0
    -- while num ~= 2000 do
    --     num += 5
    --     local fab = shared.GameClasses.Fabricator.new("Fabricator_T1")
    --     fab:Init(Vector3.new(num, 0, 0))
    --     fab:Start()
    --     task.wait(2)
    -- end
end

return self
