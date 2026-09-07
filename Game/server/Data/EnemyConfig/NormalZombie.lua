return {
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
    AnimNames = {
        [1] = "ZombieWalk_001",
        [2] = "ZombieIdle_001",
        [3] = "ZombieAttack_002"
    },
    AnimTracks = {},

}