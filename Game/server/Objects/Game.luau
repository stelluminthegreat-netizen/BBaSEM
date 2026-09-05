local self = {}

function self.initialize()
	
end

function self.start()
    local num = 0
    while task.wait() and num ~= 1 do
        num += 1
        local pivot = CFrame.new(Vector3.new(70, 0.5, -33.46))
        local enemy = shared.GameClasses.Enemy.new("NormalZombie")
        enemy:Init(pivot)
        enemy:Start()
    end
    local turret = shared.GameClasses.Turret.new("MG_001")
    turret:Init()
    turret:Start()
end

return self
