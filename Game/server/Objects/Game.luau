local self = {}

function self.initialize()
	
end

function random()
    return math.random(-20, 50)
end

function self.start()
    game.Players.PlayerAdded:Wait()
    print("Added")
    task.wait(7)
    print("Starting")
    local num = 0
    local turretStart = 0
    local enemyStart = 0
    task.spawn(function()
       while true do
        enemyStart += 1
        if enemyStart == 100 then break end
        local pivot = CFrame.new(Vector3.new(random(), 0.5, random()))
        local enemy = shared.GameClasses.Enemy.new("NormalZombie")
        enemy:Init(pivot)
        enemy:Start()
        -- task.wait(0.01)
        print(enemyStart)
       end
    end)
    task.spawn(function()
        while task.wait(5) and num ~= 2 do
            num += 1

            turretStart += 5
            local turret = shared.GameClasses.Turret.new("MG_001")
            turret:Init(Vector3.new(0, 0.1, -turretStart))
            turret:Start()

            -- task.wait(20)
        end
    end)

    local num = 0
    while num ~= 20 do
        num += 5
        local fab = shared.GameClasses.Fabricator.new("Fabricator_T1")
        fab:Init(Vector3.new(num, 0, 0))
        fab:Start()
        task.wait(2)
    end
end

return self
