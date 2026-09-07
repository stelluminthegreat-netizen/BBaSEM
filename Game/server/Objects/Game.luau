local self = {}

function self.initialize()
	
end

function random()
    return math.random(1, 120)
end

function self.start()
    local num = 0
    local turretStart = 0
    local enemyStart = 0
    task.spawn(function()
       while task.wait(1) do
         -- enemyStart += 30
        local pivot = CFrame.new(Vector3.new(random(), 0.5, random()))
        local enemy = shared.GameClasses.Enemy.new("NormalZombie")
        enemy:Init(pivot)
        enemy:Start()
       end
    end)
    while task.wait() and num ~= 5 do
        num += 1

        turretStart += 30
        local turret = shared.GameClasses.Turret.new("MG_001")
        turret:Init(Vector3.new(turretStart, 0.1, 100))
        turret:Start()
    end
end

return self
