if(instance_exists(obj_player))
{
    pl = obj_player
    pl.hp_max = stats.hp_max * statsmult.hp_max
    pl.jump_speed = stats.jumpspd * statsmult.jumpspd

    pl.walksp = stats.spd * statsmult.spd
    pl.ground_accel = stats.ground_accel * (pl.walksp / 2)
    pl.ground_fric = stats.ground_fric * (pl.walksp / 2)
    pl.air_accel = stats.air_accel * (pl.walksp / 2)
    pl.air_fric = stats.air_fric * (pl.walksp / 2)
}
if(instance_exists(oGun))
{
    gun = oGun
    gun.firerate = stats.firerate * statsmult.firerate
}
