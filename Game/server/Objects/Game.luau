local self = {}

function self.initialize()
	
end

function self.start()
    local num = 0
    local turretStart = 0
    local enemyStart = 0
    while task.wait() and num ~= 5 do
        num += 1
        turretStart += 30
        enemyStart += 30
        local pivot = CFrame.new(Vector3.new(enemyStart, 0.5, 0))
        local enemy = shared.GameClasses.Enemy.new("NormalZombie")
        enemy:Init(pivot)
        enemy:Start()

        local turret = shared.GameClasses.Turret.new("MG_001")
        turret:Init(Vector3.new(turretStart, 0.1, 100))
        turret:Start()
    end
end

return self
