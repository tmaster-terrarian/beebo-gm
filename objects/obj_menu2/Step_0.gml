m_options_length = array_length(m_options[m_submenu]);

key_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || gamepad_button_check_pressed(0, gp_padu);
key_dn = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")) || gamepad_button_check_pressed(0, gp_padd);
key_rt = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")) || gamepad_button_check_pressed(0, gp_padr);
key_lt = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")) || gamepad_button_check_pressed(0, gp_padl);
key_en = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face1);

m_pos += key_dn - key_up;

if(m_pos >= m_options_length) m_pos = 0;
if(m_pos < 0) m_pos = m_options_length - 1;
// if(m_pos >= m_options_length) m_pos = m_pos - m_options_length;
// if(m_pos < 0) m_pos = m_options_length + m_pos;

if(key_up || key_dn)
{
    ScreenShakeCursed(1, 10);
    audio_play_sound(sn_explosion, 2, false);
}
if(key_rt || key_lt)
{
    ScreenShakeCursed(1, 10);
    audio_play_sound(snShot, 1, false);
}

if(keyboard_check_pressed(vk_f2))
{
    m_submenu = 2;
    m_options_length = array_length(m_options[m_submenu]);
    m_pos = 0;
}

//selection
if(key_en)
{
    audio_play_sound(sn_menu_select, 2, false);
    switch(m_submenu)
    {
        case 0:
        {
            switch(m_pos)
            {
                case 3:
                {
                    pressedmemebutton = false;
                    m_submenu = 1;
                    m_options_length = array_length(m_options[m_submenu]);
                    m_pos = 0;
                    break;
                }
                case 4:
                {
                    global.speedrun_mode = !global.speedrun_mode;
                    ini_open("save.ini");
                    ini_write_real("settings", "speedrun_mode", global.speedrun_mode);
                    ini_close();
                    break;
                }
                case 5:
                {
                    if(global.rich_presence == 1)
                    {
                        global.rich_presence = 0
                        with(gm.neko)
                        {
                            alarm[1] = 1
                        }
                    }
                    else
                    {
                        global.rich_presence = 1
                        gm.neko = instance_create_depth(x, y, 0, objNekoPresenceDemo)
                    }
                    ini_open("save.ini");
                    ini_write_real("settings", "rich_presence", global.rich_presence);
                    ini_close();
                    break;
                }
                case 6:
                {
                    ScreenShakeCursed(6, 60);
                    ini_open("save.ini");
                    ini_key_delete("savedata", "stage");
                    ini_key_delete("savedata", "t");
                    ini_close();
                    break;
                }
                case 7:
                {
                    gm_room_transition_direct(rMenu, TRANS_TYPE.BOX)
                    break;
                }
            }
            break;
        }
        case 1:
        {
            switch(m_pos)
            {
                case 0:
                {
                    if(pressedmemebutton == false)
                    {
                        pressedmemebutton = true;
                        audio_play_sound(sn_tp, 3, false);
                        var memeplayer = instance_create_depth(m_x + m_w * 0.5, m_y + m_h * 0.5, 300, obj_player);
                        var memegun = instance_create_depth(m_x + m_w * 0.5, m_y + m_h * 0.5 + 16, 200, oGun);
                        var memeenemy = instance_create_depth(m_x + m_w * 0.5, m_y + m_h * 0.5, 300, obj_enemy);
                        instance_create_depth(m_x, m_y, 400, oCrate);
                    }
                    break;
                }
                case 1:
                {
                    m_submenu = 0;
                    m_options_length = array_length(m_options[m_submenu]);
                    m_pos = 0;
                    break;
                }
            }
            break;
        }
        case 2:
        {
            switch(m_pos)
            {
                case 2:
                {
                    test_checkbox = !test_checkbox;
                    break;
                }
                case 3:
                {
                    m_submenu = 0;
                    m_options_length = array_length(m_options[m_submenu]);
                    m_pos = 0;
                    break;
                }
            }
            break;
        }
    }
}

if(keyboard_check_pressed(vk_escape)) || (gamepad_button_check_pressed(0, gp_face2))
{
    switch(m_submenu)
    {
        case 0:
        {
            
            gm_room_transition_direct(rMenu, TRANS_TYPE.BOX)
            break;
        }
        case 1: case 2:
        {
            m_submenu = 0;
            m_options_length = array_length(m_options[m_submenu]);
            m_pos = 0;
            break;
        }
    }
}

//sliders
switch(m_submenu)
{
    case 0:
    {
        switch(m_pos)
        {
            case 0:
            {
                if(key_rt)
                {
                    global.screenSize++;

                    if(global.screenSize > 7)
                    {
                        global.screenSize = 7;
                    }
                    if(global.screenSize < 7)
                    {
                        window_set_fullscreen(false);
                        window_set_size((256 * global.screenSize), (144 * global.screenSize));
                        window_center()
                    }
                    else
                    {
                        window_set_fullscreen(true);
                    }

                    ini_open("save.ini");
                    ini_write_real("settings", "res", global.screenSize);
                    ini_close();
                }
                if(key_lt)
                {
                    global.screenSize--;

                    if(global.screenSize < 1)
                    {
                        global.screenSize = 1;
                    }
                    if(global.screenSize < 7)
                    {
                        window_set_fullscreen(false);
                        window_set_size((256 * global.screenSize), (144 * global.screenSize));
                        window_center()
                    }
                    else
                    {
                        window_set_fullscreen(true);
                    }

                    ini_open("save.ini");
                    ini_write_real("settings", "res", global.screenSize);
                    ini_close();
                }
                break;
            }
            case 1:
            {
                if(key_rt)
                {
                    global.snd_volume = clamp(global.snd_volume + 0.1, 0, 1);
                    audio_group_set_gain(audiogroup_default, global.snd_volume, 0);
                    ini_open("save.ini");
                    ini_write_real("settings", "sound_volume", global.snd_volume);
                    ini_close();
                }
                if(key_lt)
                {
                    global.snd_volume = clamp(global.snd_volume - 0.1, 0, 1);
                    audio_group_set_gain(audiogroup_default, global.snd_volume, 0);
                    ini_open("save.ini");
                    ini_write_real("settings", "sound_volume", global.snd_volume);
                    ini_close();
                }
                break;
            }
            case 2:
            {
                if(key_rt)
                {
                    global.bgm_volume = clamp(global.bgm_volume + 0.1, 0, 1);
                    audio_group_set_gain(audiogroup_bgm, global.bgm_volume, 0);
                    ini_open("save.ini");
                    ini_write_real("settings", "music_volume", global.bgm_volume);
                    ini_close();
                }
                if(key_lt)
                {
                    global.bgm_volume = clamp(global.bgm_volume - 0.1, 0, 1);
                    audio_group_set_gain(audiogroup_bgm, global.bgm_volume, 0);
                    ini_open("save.ini");
                    ini_write_real("settings", "music_volume", global.bgm_volume);
                    ini_close();
                }
                break;
            }
        }
        break;
    }
    case 2:
    {
        switch(m_pos)
        {
            case 1:
            {
                if(key_rt)
                {
                    test_slider = clamp(test_slider + 0.1, 0, 1);
                }
                if(key_lt)
                {
                    test_slider = clamp(test_slider - 0.1, 0, 1);
                }
                break;
            }
        }
        break;
    }
}
