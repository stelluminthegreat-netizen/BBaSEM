local self = {}

function self.initialize()
	
end

function random()
    return math.random(-90, 100)
end

function self.start()
    local num = 0
    local turretStart = 0
    local enemyStart = 0
    task.spawn(function()
       while true do
        enemyStart += 1
        if enemyStart == 1000 then break end
        local pivot = CFrame.new(Vector3.new(random(), 0.5, random()))
        local enemy = shared.GameClasses.Enemy.new("NormalZombie")
        enemy:Init(pivot)
        enemy:Start()
        task.wait(0.5)
       end
    end)
    task.spawn(function()
        while task.wait() and num ~= 5 do
            num += 1

            turretStart += 30
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
