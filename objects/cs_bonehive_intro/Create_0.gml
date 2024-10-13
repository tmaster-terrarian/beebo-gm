tl_position = 0
tl_running = 1

gate1 = noone
gate2 = noone

bonehive = instance_create_depth(x, y + 64, 300, obj_boss_bonehive)
gm.currentboss = bonehive
if(global.bonehive_started == 0)
{
    global.bonehive_started = 1
    with(obj_player)
    {
        facing = 1
        hsp = 0
    }
    with(bonehive)
    {
        state = "intro"
    }
    with(gm) audio_sound_gain(current_bgm, 0, 1000)
    introsound = audio_play_sound(sn_bonehive_intro, 0, false)
    global.cutscene = 1
}
else
{
    instance_destroy(obj_animeRival)
    obj_player.x = 496
    obj_player.y = 128
    gate1 = instance_create_depth(x - 120, y + 112, 750, obj_bossgate)
    gate2 = instance_create_depth(x + 120, y + 128, 750, obj_bossgate)
    with(bonehive)
    {
        state = "normal"
        timer0 = -1
    }
    SetMusic(bgm_project3)
    with(gm) audio_sound_gain(current_bgm, 1, 0)
    gm.drawbossbar = 1
    tl_position = 60 * 14
}
