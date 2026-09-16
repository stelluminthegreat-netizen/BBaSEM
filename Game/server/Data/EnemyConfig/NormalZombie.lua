return {
    MaxHealth = 100,
    Health = 100,
    
    Dmg = 5,
    WalkSpeed = 0.1,
    AttackSpd = 1,
    Hitbox = Vector3.new(3, 5, 3),
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