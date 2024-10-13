if(!global.console)
    tl_running = 1

switch(tl_position)
{
    case 0:
    {
        gate1 = instance_create_depth(x - 120, y + 112, 750, obj_bossgate)
        gate2 = instance_create_depth(x + 120, y + 128, 750, obj_bossgate)
        break
    }
    case 60:
    {
        with(obj_player)
        {
            facing = -1
        }
        ScreenShake(2, 6 * 60, false)
        break
    }
    case 60 * 6:
    {
        audio_sound_gain(introsound, 0, 1000)
        with(bonehive)
        {
            use_target = 1
            target_sp = 10
        }
        with(obj_player)
        {
            sprite_index = spr_player_lookup
        }
        break
    }
    case 60 * 7:
    {
        audio_play_sound(sn_bonehive_roar, 0, false)
        ScreenShake(4, 7 * 60, false)
        with(bonehive)
        {
            target_sp = 3
        }
        break
    }
    case 60 * 14:
    {
        audio_play_sound(sn_tp, 0, false)
        SetMusic(bgm_project3)
        with(gm) audio_sound_gain(current_bgm, 1, 0)
        with(bonehive)
        {
            target_node = choose(nodes[1], nodes[2], nodes[3], nodes[4])
            state = "normal"
        }
        tl_position += 1
        tl_running = 0
        global.cutscene = 0
        gm.drawbossbar = 1
        break
    }
    case 841:
    {
        if(bonehive.hp <= 0)
        {
            instance_destroy(obj_trigger_camera_pos)
            with(o_nectar) hp = 0
            tl_position += 1
            tl_running = 1
            global.cutscene = 1
            StopMusic()
            room_speed = 15
            with(bonehive)
            {
                state = "intro"
                use_target = 0
                shaking = 1
                shake = 3
                x = other.x
                y = 64
            }
            with(oCamera)
            {
                xTo = 592
                yTo = 64
                usefollow = 0
                zoom = 2
            }
            with(obj_player)
            {
                x = 608
                y = 112
                facing = -1
                hsp = 0
            }
        }
        else tl_running = 0
        break
    }
    case 860:
    {
        oCamera.zoom = 1
        break
    }
    case 870:
    {
        gm.drawbossbar = 0
        gm.currentboss = noone
        with(bonehive)
        {
            MakeExplosion(x, y, 1.5, 1.5, 0.4)
            shaking = 0
            bits = 0
            for(var i = 0; i < 5; i++)
            {
                with(instance_create_depth(x, y, depth + i, obj_gib))
                {
                    rotate_with_speed = 1
                    destroy_on_timer = 0
                    hsp = random_range(0.5, 1) * choose(1, -1)
                    vsp = random_range(-2, -1)
                    sprite_index = spr_gib_bonehive
                    image_index = i
                }
                with(instance_create_depth(x + irandom_range(-16, 16), y + irandom_range(-16, 16) + 12, depth, obj_hpup))
                {
                    hsp = 0
                    vsp = 0
                    grv = 0
                }
            }
            with(instance_create_depth(par_wingr.x, par_wingr.y, depth + 5, obj_gib))
            {
                rotate_with_speed = 1
                destroy_on_timer = 0
                hsp = random_range(1, 1.2) * 1
                vsp = random_range(-2, -1)
                sprite_index = spr_gib_bonehive_wing
                image_angle = other.par_wingr.image_angle
                image_xscale = 1
            }
            with(instance_create_depth(par_wingl.x, par_wingl.y, depth + 5, obj_gib))
            {
                rotate_with_speed = 1
                destroy_on_timer = 0
                hsp = random_range(1, 1.2) * -1
                vsp = random_range(-2, -1)
                sprite_index = spr_gib_bonehive_wing
                image_angle = other.par_wingl.image_angle
                image_xscale = -1
            }
            instance_destroy(par_wingr)
            instance_destroy(par_wingl)
            instance_destroy(par_head)
            instance_destroy(par_jawboned)
            scr_particle_explode()
        }
        break
    }
    case 875:
    {
        room_speed = 60
        break
    }
    case 950:
    {
        tl_running = 0
        global.cutscene = 0
        with(oCamera)
        {
            usefollow = 1
        }
        with(gate2)
            event_perform(ev_other, ev_user0)
        instance_destroy()
    }
}

if(tl_position < 75) || (tl_position > 841)
    with(obj_player)
        sprite_index = spr_player

if(tl_position >= 420 && tl_position <= 440)
    with(bonehive) par_jawboned_y = approach(par_jawboned_y, -8, 0.15)

if(tl_position >= 830 && tl_position <= 840)
    with(bonehive) par_jawboned_y = approach(par_jawboned_y, -12, 0.5)

if(tl_running)
{
    tl_position++
    obj_player.hsp = 0
}
