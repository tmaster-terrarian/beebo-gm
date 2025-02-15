if(!obj_player.hascontrol || obj_player.state == "stunned" || obj_player.state == "donothing")
{
    sprite_index = sGun;
    image_index = 0;
    image_speed = 0;

    if(sign(obj_player.facing) == 1)
    {
        image_yscale = 1;
        image_angle = 0;
    }
    if(sign(obj_player.facing) == -1)
    {
        image_yscale = -1;
        image_angle = 180;
    }
    return;
}
if(global.console) return;

if(global.controller)
{
    gamepad_set_axis_deadzone(0, 0.15);

    aim_x = (abs(gamepad_axis_value(0, gp_axisrh)) || abs(gamepad_axis_value(0, gp_axisrv))) ? gamepad_axis_value(0, gp_axisrh) : gamepad_axis_value(0, gp_axislh);
    aim_y = (abs(gamepad_axis_value(0, gp_axisrh)) || abs(gamepad_axis_value(0, gp_axisrv))) ? gamepad_axis_value(0, gp_axisrv) : gamepad_axis_value(0, gp_axislv);
    // aim_w = lengthdir_x(abs(aim_x), point_direction(0, 0, aim_x, aim_y));
    // aim_h = lengthdir_y(abs(aim_y), point_direction(0, 0, aim_x, aim_y));
    var _aim_n = normalize(aim_x, aim_y);
    aim_w = _aim_n[0];
    aim_h = _aim_n[1];

    gamepad_set_axis_deadzone(0, 0.2);

    if(aim_w != 0) && (aim_h != 0)
    {
        image_angle = point_direction(0, 0, aim_w, aim_h);
    }
    else
    {
        if(instance_exists(obj_player))
        {
            if(sign(obj_player.facing) == 1)
            {
                image_yscale = 1;
                image_angle = 0;
            }
            if(sign(obj_player.facing) == -1)
            {
                image_yscale = -1;
                image_angle = 180;
            }
        }
    }

    // if(gamepad_button_check_pressed(0, gp_stickr))
    // {
    //     lock = !lock;
    // }

    if(lock)
    {
        // if(instance_exists(obj_robo)) {lock_target = instance_nearest(x + aim_w, y + aim_h, obj_robo); image_angle = point_direction(x, y, lock_target.x, lock_target.y);}
        if(instance_exists(obj_animeRival)) {lock_target = obj_animeRival; image_angle = point_direction(x, y, lock_target.x, lock_target.y);}
        else if(instance_exists(obj_boss)) {lock_target = obj_boss; image_angle = point_direction(x, y, lock_target.x, lock_target.y);}
        else lock = false;
    }
    else lock_target = noone;
}
else if(idle_counder < 180)
{
    image_angle = point_direction(x, y, mouse_x, mouse_y);
    image_angle = round(image_angle / 10) * 10;
}

if(obj_player.state == "normal" && idle_counder < 180)
{
    if (image_angle > 90 && image_angle < 270)
    {
        image_yscale = -1;
        obj_player.facing = -abs(obj_player.facing);
    }
    else
    {
        image_yscale = 1;
        obj_player.facing = abs(obj_player.facing);
    }
}
else
{
    if (image_angle > 90 && image_angle < 270)
    {
        image_yscale = -1;
    }
    else
    {
        image_yscale = 1;
    }
}

firingdelay--;
recoil = max(0, recoil - 1);
if(mouse_check_button(mb_left) || gamepad_button_check(0, gp_shoulderrb)) && (firingdelay <= 0)
{
    fire = 1;
    if(obj_player.hp > 1)
    {
        ScreenShake(1, 5);
        recoil = 2;
        firingdelay = firerate;

        var v = spread
        if(obj_player.state == "grind")
            v = spread / 2

        with (instance_create_depth(x, y, depth - 3, oBullet))
        {
			parent = obj_player
            _team = team.player
            audio_play_sound(snShot, 1, false);

            speed = 12;
            direction = other.image_angle + random_range(-v, v);
            image_angle = direction;

            damage = obj_player.damage
        }
        with(instance_create_depth(x + lengthdir_x(4, image_angle), y + lengthdir_y(4, image_angle) - 1, depth - 5, fx_casing))
        {
            image_yscale = other.image_yscale
            angle = other.image_angle
            dir = other.image_yscale
            hsp = -other.image_yscale * random_range(1, 1.5)
            vsp = -1 + random_range(-0.2, 0.1)
        }
    }
    else
    {
        ScreenShake(3, 5);
        recoil = 3;
        firingdelay = firerate * 1.5;

        for(var i = 0; i < 2; i++)
        {
            with (instance_create_depth(x + lengthdir_x(12, image_angle), y + lengthdir_y(12, image_angle) - 1, depth - 3, obj_helix_bullet))
            {
				parent = obj_player
                _team = team.player
                audio_play_sound(sn_helix_laser2, 1, false);

                var dist = max(point_distance(x, y, mouse_x, mouse_y), 32)

                s = max(dist / 28, 4)
                d = dist
                dd = 1/d
                a = dd * pi
                dis = min(max(8, dist / 4), 32)
                dir = other.image_angle
                u = -2 * i + 1
                image_index += i

                damage = obj_player.damage
            }
        }
    }

    heat = approach(heat, heat_max, heatspd);
    var n = irandom_range(0, heat_max/heat);
    if(n == 0)
    {
        var dist = random_range(0.1, 1) * 12;
        with(instance_create_depth(x + lengthdir_x(dist, image_angle), (y - 2) + lengthdir_y(dist, image_angle), depth - 1, fx_dust))
        {
            vy = random_range(-1.5, -1)
            vx += obj_player.hsp + ((obj_player.state == "grind") * -6)
        }
    }
}
else if(firingdelay <= 0)
{
    heat = approach(heat, 0, coolspd);
    if(floor(heat) mod 8 == 7)
    {
        var dist = random_range(0.1, 1) * 12;
        with(instance_create_depth(x + lengthdir_x(dist, image_angle), (y - 2) + lengthdir_y(dist, image_angle), depth - 1, fx_dust))
        {
            vy = random_range(-1.5, -1) + obj_player.vsp
            vx += obj_player.hsp + ((obj_player.state == "grind") * -6)
        }
        audio_play_sound(sn_steam, 1, false, heat/heat_max);
    }
}

image_blend = merge_color(c_white, c_red, (heat/heat_max)*0.5);

if(mouse_check_button_pressed(mb_right) || gamepad_button_check_pressed(0, gp_shoulderlb)) && (firingdelaybomb > 0)
{
    event_perform(ev_alarm, 0)
}

firingdelaybomb--;
if (mouse_check_button(mb_right) || gamepad_button_check(0, gp_shoulderlb)) && (firingdelaybomb <= 0)
{
    event_perform(ev_alarm, 0)

    fire = 1;

    ScreenShake(2, 10);
    recoil = 4;
    firingdelaybomb = bomb_timer_max;
    audio_play_sound(sn_throw, 1, false);

    // firebomb = 1;
    sprite_index = sGunR;
    image_index = 0;
    image_speed = 0.25;

    with (instance_create_depth(x + lengthdir_x(12, image_angle), y + lengthdir_y(12, image_angle) - 1, depth - 2, bomb_projectile))
    {
        parent = obj_player
        _team = team.player
        switch(object_index)
        {
            case obj_bomb:
            {
                damage = obj_player.damage * 5
                direction = other.image_angle;
                hsp = lengthdir_x(2, direction) + (obj_player.hsp * 0.5) + ((obj_player.state == "grind") * -0.5);
                vsp = lengthdir_y(2, direction) + (obj_player.vsp * 0.25) - 1;
                if((vsp > 0.2) && (obj_player.state == "grind")) max_bounces = 0

                if(mouse_check_button(mb_left) || gamepad_button_check(0, gp_shoulderrb)) event_perform(ev_other, ev_user2);

                break
            }
        }
    }
}

//animation
if (mouse_check_button_released(mb_left) || gamepad_button_check_released(0, gp_shoulderrb))
{
    sprite_index = sGunR;
    image_index = 0;
    image_speed = 0.2;
}
if (sprite_index == sGunR)
{
    if(image_index == 1)
    {
        audio_play_sound(sn_gun_open, 1, false);
    }
    if(image_index == 2)
    {
        audio_play_sound(sn_steam, 1, false);
        for (i = 0; i < 3; i++)
        { 
            with(instance_create_depth(x + random_range(-1, 1), y + random_range(-1, 1), depth - 1, fx_dust))
            {
                vy = random_range(-1.5, -0.75);
                vx = random_range(1.5, 2) * other.image_yscale + obj_player.hsp + ((obj_player.state == "grind") * -6);
            }
        }
    }
    if(image_index == 5)
    {
        if(firebomb)
        {
            firebomb = 0;
            sprite_index = sGun;
            image_index = 0;
            image_speed = 0;
        }
        else audio_play_sound(snReload, 0, false);
    }
    if(image_index >= image_number - 1)
    {
        sprite_index = sGun;
        image_index = 0;
        image_speed = 0;
    }
}

if(obj_player.fxtrail)
{
    if ((obj_player.trailTimer % 4) == 1)
    {
        with (instance_create_depth(x, y, (depth + 101), fx_aura))
        {
            visible = true
            image_speed = 0
            image_index = other.image_index
            sprite_index = other.sprite_index
            image_xscale = other.image_xscale
            image_yscale = other.image_yscale
            image_angle = other.image_angle
            if(obj_player.state == "grind")
            {
                hspeed = -6
            }
        }
    }
}

if !global.controller
{
    if(lastmousex == window_mouse_get_x() && lastmousey == window_mouse_get_y() && !fire)
        idle_counder++
    else
        idle_counder = 0
    if(idle_counder > 180 && idle_counder < 190)
    {
        var _target_angle = 0
        if(sign(obj_player.facing) == 1)
        {
            image_yscale = 1;
            _target_angle = 0;
        }
        if(sign(obj_player.facing) == -1)
        {
            image_yscale = -1;
            _target_angle = 180;
        }
        image_angle += ((_target_angle - 180) - (image_angle - 180)) / 4 + 180
    }
    if(idle_counder >= 190)
    {
        if(sign(obj_player.facing) == 1)
        {
            image_yscale = 1;
            image_angle = 0;
        }
        if(sign(obj_player.facing) == -1)
        {
            image_yscale = -1;
            image_angle = 180;
        }
    }
    lastmousex = window_mouse_get_x()
    lastmousey = window_mouse_get_y()
}
else
{
    idle_counder = 0
}
fire = 0
