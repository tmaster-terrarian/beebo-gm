with(obj_player)
{
    foreach(buffs as (buff)
    {
        buff.step()
        buff.tick(id)
    })

    for(var i = 0; i < array_length(items); i++)
    {
        global.itemdefs[$ items[i].item_id].step(id, items[i].stacks)
    }

    statsmult = 
    {
        hp_max : 1,
        regen_rate : 1,
        spd : 1,
        jumpspd : 1,
        firerate : 1,
        spread : 1,
        damage : 1,
        crit_chance : 0
    }

    var spdadd = 1
    spdadd += (variable_struct_exists(buffs, "buff_fast")) ? buffs.buff_fast.calc() : 0

    var spdsub = 1
    spdsub += (variable_struct_exists(buffs, "debuff_slow")) ? buffs.debuff_slow.calc() : 0

    statsmult.spd = spdadd / spdsub

    if ((hp / hp_max) != (hp / (stats.hp_max * statsmult.hp_max)))
    {
        hp *= statsmult.hp_max
        lasthp *= statsmult.hp_max
        oCamera.hp_change *= statsmult.hp_max
    }

    hp_max = stats.hp_max * statsmult.hp_max
    regen_rate = stats.regen_rate * statsmult.regen_rate
    walksp = stats.spd * statsmult.spd
    jump_speed = stats.jumpspd * statsmult.jumpspd

    ground_accel = stats.ground_accel * (walksp / stats.spd)
    ground_fric = stats.ground_fric * (walksp / stats.spd)
    air_accel = stats.air_accel * (walksp / stats.spd)
    air_fric = stats.air_fric * (walksp / stats.spd)

    damage = stats.damage * statsmult.damage

    crit_chance = clamp(statsmult.crit_chance, 0, 1)
    if(crit_chance == 0) crit_chance += 0.01

    statsmult.spread -= 0.1 * item_get_stacks("beeswax", id)
    if(statsmult.spread < 0) statsmult.spread = 0

    with(oGun)
    {
        firerate = other.stats.firerate * other.statsmult.firerate
        spread = other.stats.spread * other.statsmult.spread
    }
}

with(par_enemy)
{
    foreach(buffs as (buff)
    {
        buff.step()
        buff.tick(id)
    })

    for(var i = 0; i < array_length(items); i++)
    {
        global.itemdefs[$ items[i].item_id].step(id, items[i].stacks)
    }

    statsmult =
    {
        hp_max : 1,
        spd : 1,
        firerate : 1,
        damage : 1,
        crit_chance : 0
    }

    var spdadd = 1
    spdadd += (variable_struct_exists(buffs, "buff_fast")) ? buffs.buff_fast.calc() : 0

    var spdsub = 1
    spdsub += (variable_struct_exists(buffs, "debuff_slow")) ? buffs.debuff_slow.calc() : 0

    statsmult.spd = spdadd / spdsub

    damage = stats.damage * statsmult.damage

    crit_chance = clamp(statsmult.crit_chance, 0, 1)

    hp_max = stats.hp_max * statsmult.hp_max
    spd = stats.spd * statsmult.spd
    firerate = stats.firerate * statsmult.firerate
    damage = stats.damage * statsmult.damage
}
