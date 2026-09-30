return {
    Level = 1,
    
    MaxHealth = 500,
    Health = 500,
    
    Dmg = 2,
    WalkSpeed = 0.05,
    AttackSpd = 2,
    Hitbox = Vector3.new(1, 5, 1),
    CurrentTarget = "",
    FindTargetRange = Vector3.new(100, 100, 100),
    State = {
        Attacking = false,
    },
    InAttRange = {},
    Conns = {},
    Events = {},
    EventNames = {
        [1] = "Destroyed",
        [2] = "Died",
    },
    HitDelay = 0.7,
    RemainingDelay = 0.2,
}