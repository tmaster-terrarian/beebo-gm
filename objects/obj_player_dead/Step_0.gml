if (done == false)
{
	hsp = move;
	vsp += grv;

    //move and collisions
    //horizontal
	if (oob == false)
    if (place_meeting(x + hsp, y, obj_wall))
    {
        while (!place_meeting(x + sign(hsp), y, obj_wall))
        {
            x += sign(hsp);
        }
        hsp = 0;
    }
    x += hsp;

    //vertical
	if (oob == false)
    if (place_meeting(x, y + vsp, obj_wall))
    {
        if (vsp > 0)
        {
            done = true;
			audio_play_sound(sn_antic_gyui, 1, false);

			if irandom_range(1, 1000) == 1
				image_index = 2;
			else
				image_index = 1;
        }
        else while (!place_meeting(x, y + sign(vsp), obj_wall))
        {
            y += sign(vsp);
        }
        vsp = 0;
    }
    y += vsp;
}
else
{
	if(oob == true)
	{
		vsp -= grv;

		xTo = oCamera.x;
		yTo = oCamera.y;

		x += (xTo - x) / 12;
		y += (yTo - y) / 12;
	}

	bg.x = camera_get_view_x(cam) - 8;
	bg.y = camera_get_view_y(cam) - 8;

	with(obj_gun_dead)
	{
		done = true;
		image_angle -= 5;
		xTo = other.x;
		yTo = other.y - 4;

		x += (xTo - x) / 12;
		y += (yTo - y) / 12;
	}
	explosiontimer--;
    if(explosiontimer < 0)
    {
		if(timer_finished == false)
		{
			timer_finished = true;
			with(oCrate) hp = 0;
			with(obj_stone) hp = 0;
			with(obj_enemy) hp = 0;
			with(obj_gun_dead) scr_particle_explode();
			audio_play_sound(snBigExplode, 10, false);
			x = round(x);
			y = round(y);
		}

		var posx = random_range(x - 16, x + 16);
		var posy = random_range(y - 16, y + 16);
		var chance = random_range(1, 4);

		if(chance > 3)
		{
			shake_length = 20;
			shake_magnitude = 2;
			shake_remain = 2;
			ScreenShake(4, 40);
			MakeExplosion(posx, posy, 4, 4, 2, sn_explosion, depth + 150);
		}
    }
	if(explosiontimer == -5)
	{
		with(obj_pixel)
		{
			active = 1;
			deact = 10;
			ticker = 10;
			image_alpha = 10;
			hspeed *= lengthdir_x(10, point_direction(x, y, other.x, other.y));
			vspeed *= lengthdir_y(-10, point_direction(x, y, other.x, other.y));
		}
	}
}
bg.image_alpha = (-1 * (explosiontimer / 80) + 1);

if(keyboard_check_pressed(vk_space)) || (keyboard_check_pressed(vk_enter)) || (gamepad_button_check_pressed(0, gp_face1))
{
	global.pausetimer = false;
	global.playerhealth = hp_max;
	with(gm) {audio_sound_gain(current_bgm, 1, 500); audio_sound_set_track_position(current_bgm, 0)}
	gm_room_transition_direct(rm, TRANS_TYPE.BOX);
	scr_particle_explode2();
}
