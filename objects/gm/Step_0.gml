var _dt = delta_time / 1000000

// screen transition stuff
if(mode != TRANS_MODE.OFF)
{
    if(mode == TRANS_MODE.ACTIVE || mode == TRANS_MODE.ACTIVE2)
    {
        percent = max(0, percent - max((percent / 5), 0.005));
    }
    else
    {
        percent = min(1.2, percent + max(((1.2 - percent) / trans_speed), 0.005))
    }

    if(percent == 1.2) || (percent == 0)
    {
        switch mode
        {
            case TRANS_MODE.ACTIVE:
                mode = TRANS_MODE.OFF
            break
            case TRANS_MODE.ACTIVE2:
                mode = TRANS_MODE.OFF
            break
            case TRANS_MODE.DIRECT:
                mode = TRANS_MODE.ACTIVE
                console_log("loading room (mode: direct): '" + string(room_get_name(target)) + "' [warning: stage will not be saved!]")
                room_goto(target)
            break
            case TRANS_MODE.GOTO:
                mode = TRANS_MODE.ACTIVE
                target = stages[target_st, target_rm]
                if(current_st != target_st) && (current_st != -1)
                {
                    console_log("loading room (mode: goto): " + string(room_get_name(target) + " (" + string(target_st) + ", " + string(target_rm) + ")"))
                    scr_loadingscreen(target, stage_tips[target_st])
                }
                else
                {
                    console_log("loading room (mode: goto): " + string(room_get_name(target) + " (" + string(target_st) + ", " + string(target_rm) + ")"))
                    room_goto(target)
                }
            break
            case TRANS_MODE.RESTART:
                if(global.rich_presence)
                {
                    audio_stop_all()
                    room_goto(boot)
                    with(all)
                    {
                        if persistent && object_index != objNekoPresenceDemo
                            instance_destroy(id)
                    }
                    instance_destroy(id)
                    return
                }
                else
                {
                    game_restart()
                    return
                }
            break
        }
    }
}

//:lollmao:
if(keyboard_check(vk_lcontrol))
{
    with(obj_player)
    {
        x = mouse_x;
        y = mouse_y;
    }
}

//hascontrol timer or something idk
if(!global.console) controltimer = max(0, controltimer - 1);
with(obj_player)
{
    if(other.controltimer > 0) || (global.cutscene == true)
    {
        hascontrol = false;
    }
    else hascontrol = true;
}

//console
if(keyboard_check_pressed(vk_f1))
{
    global.console = true;
    input_str = "";
    controltimer = 99999999;
}
if(global.console)
{
    cursor_timer = max(0, cursor_timer - 1);
    if(cursor_timer == 0) cursor_timer = 60;

    if(keyboard_check(vk_lshift))
    {
        log_pos += mouse_wheel_up() * 40;
        log_pos -= mouse_wheel_down() * 40;
    }
    else
    {
        log_pos += mouse_wheel_up() * 10;
        log_pos -= mouse_wheel_down() * 10;
    }

    log_pos = max(log_pos, 0);

    if(keyboard_check_pressed(vk_escape))
    {
        global.console = false;
        input_str = "";
        keyboard_string = "";
        controltimer = 0;
    }

    if(keyboard_check_pressed(vk_up))
    {
        input_str = last_input_str;
        keyboard_string = last_input_str;
    }

    if(keyboard_check_pressed(vk_enter))
    {
        //basic one-word commands
        switch(input_str)
        {
            default:
            {
                if(keyboard_string != "") console_log("| " + keyboard_string);
                break;
            }

            case "clear":
            {
                log_str = "";
                break;
            }

            case "restart":
            {
                gm_room_transition_restart();
                break;
            }

            case "goto_next":
            {
                gm_room_transition_next();
                break;
            }

            case "view_rival":
            {
                with(oCamera) follow = obj_animeRival;
                break;
            }

            case "view_player":
            {
                with(oCamera) follow = obj_player;
                break;
            }

            case "kill":
            {
                with(obj_player) hp = 0;
                break;
            }

            case "benbo":
            {
                console_log("fuck you");
                break;
            }

            case "animemode":
            {
                global.animemode = !global.animemode;
                if(global.animemode == 1) console_log("wtf??!??!?!?");
                break;
            }

            case "draw_debug":
            {
                global.draw_debug = !global.draw_debug;
                console_log("draw_debug set to " + string(global.draw_debug));

                ini_open("save.ini")
                ini_write_real("debug", "draw_debug", global.draw_debug)
                ini_close()
                break;
            }

            case "impulse 101":
            {
                with(obj_gun_pickup) instance_destroy();
                if(!instance_exists(oGun))
                {
                    with(obj_player)
                    {
                        instance_create_depth(x, y, 300, oGun);
                    }
                    global.hasgun = true;
                    global.gunlesspercent = false;
                    ini_open("save.ini");
                    ini_write_real("savedata", "g", global.hasgun);
                    ini_close();
                }
                break;
            }
        }

        //more complicated argument-based commands
        if(cmd("goto_direct "))
        {
            var _args = string_split(input_str, " ");
            if(array_length(_args) == 2)
            {
                var _rm = (string_digits(_args[1]) != "") ? real(string_digits(_args[1])) : asset_get_index(string(_args[1]));
                if(_rm == 0) gm_room_transition_restart();
                else gm_room_transition_direct(_rm);
            }
            else console_log("invalid syntax! expected: goto_direct [room]");
        }

        if(cmd("goto "))
        {
            var _args = string_split(input_str, " ");
            if(array_length(_args) == 3)
            {
                gm_room_transition_goto(_args[1], real(_args[2]));
            }
            else if(array_length(_args) == 2)
            {
                gm_room_transition_goto(_args[1], 0);
            }
            else if(array_length(_args) == 1)
            {
                gm_room_transition_direct(room);
            }
            else console_log("invalid syntax! expected: goto [stage_index = 0] [room_index = 0]");
        }

        if(cmd("config_write "))
        {
            var _args = string_split(input_str, " ");
            if(array_length(_args) == 3)
            {
                ini_open("save.ini");
                ini_write_real("settings", _args[1], real(_args[2]))
                ini_close();

                // screenSize refresh
                if(global.screenSize < 1)
                {
                    global.screenSize = 1;
                }
                if(global.screenSize > 7)
                {
                    global.screenSize = 7;
                }
                if(global.screenSize < 7)
                {
                    window_set_fullscreen(false);
                    window_set_size((256 * global.screenSize), (144 * global.screenSize));
                }
                else
                {
                    window_set_fullscreen(true);
                }

                // snd_volume / bgm_volume refresh
                global.snd_volume = clamp(global.snd_volume, 0, 1);
                audio_group_set_gain(audiogroup_default, global.snd_volume, 0);
                global.bgm_volume = clamp(global.bgm_volume, 0, 1);
                audio_group_set_gain(audiogroup_default, global.bgm_volume, 0);

                console_log("set value '" + string(_args[1]) + "' to " + string(_args[2]));
            }
            else console_log("invalid syntax! expected: config_write <key> <value>");
        }

        if(cmd("config_read "))
        {
            var _args = string_split(input_str, " ");
            if(array_length(_args) == 2)
            {
                ini_open("save.ini");
                var _val = ini_read_real("settings", _args[1], -1)
                ini_close();
                if(_val != -1) console_log("'" + string(_args[1]) + "' = " + string(_val));
                else console_log("config_read failed: key '" + string(_args[1]) + "' is either unset or does not exist.");
            }
            else console_log("invalid syntax! expected: config_read <key>");
        }

        if(cmd("sp_hp "))
        {
            var _args = string_split(input_str, " ");
            if(array_length(_args) == 2)
            {
                if(instance_exists(obj_player))
                {
                    for(var i = 0; i < _args[1]; i++;)
                    {
                        instance_create_depth(obj_player.x + obj_player.facing * 32, obj_player.y, 300, obj_hpup);
                    }
                }
                else if(instance_exists(oCamera))
                {
                    for(var i = 0; i < _args[1]; i++;)
                    {
                        instance_create_depth(oCamera.x, oCamera.y, 300, obj_hpup);
                    }
                }
            }
            else if(array_length(_args) == 1)
            {
                if(instance_exists(obj_player)) instance_create_depth(obj_player.x + obj_player.facing * 32, obj_player.y, 300, obj_hpup);
                else if(instance_exists(oCamera)) instance_create_depth(oCamera.x, oCamera.y, 300, obj_hpup);
            }
            else console_log("invalid syntax! expected: sp_hp [amount = 1]");
        }

        if(cmd("set_view "))
        {
            var _args = string_split(input_str, " ");
            switch(array_length(_args))
            {
                case 1:
                {
                    if(instance_exists(obj_player)) with(oCamera) {follow = obj_player}
                    else console_log("set_view failed: could not find player");
                    break;
                }
                case 2:
                {
                    var _obj = asset_get_index(string(_args[1]));
                    if(instance_exists(_obj)) with(oCamera) {follow = _obj}
                    else console_log("set_view failed: object does not exist");
                    break;
                }
                default:
                {
                    console_log("invalid syntax! expected: set_view <object>");
                }
            }
        }

        if(cmd("spawn "))
        {
            var _args = string_split(input_str, " ");
            switch(array_length(_args))
            {
                case 2:
                {
                    var _obj = (string_digits(_args[1]) != "") ? real(string_digits(_args[1])) : asset_get_index(string(_args[1]));

                    if(_obj != -1) instance_create_depth(mouse_x, mouse_y, 350, _obj);
                    else console_log("spawn failed: object asset does not exist");
                    break;
                }
                default:
                {
                    console_log("invalid syntax! expected: spawn <object asset>");
                }
            }
        }

        if(cmd("hp "))
        {
            var _args = string_split(input_str, " ");
            switch(array_length(_args))
            {
                case 2:
                {
                    with(oCamera)
                    {
                        if(string_starts_with(_args[1], "-")) follow.hp = -1 * real(string_digits(_args[1]))
                        else follow.hp = real(string_digits(_args[1]))
                    }
                    break;
                }
                default:
                {
                    console_log("invalid syntax! expected: hp <value>");
                }
            }
        }

        if(keyboard_string != "") last_input_str = input_str;
        keyboard_string = "";
    }
    input_str = keyboard_string;
}
else keyboard_string = "";

cmd = function(command)
{
    return string_starts_with(input_str, string(command));
}

if(gamepad_button_check_any_pressed())
{
    global.controller = true
}
if(keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any))
{
    global.controller = false
}

if(global.speedrun_mode) && (global.gamestarted) && (!global.pausetimer) && (!global.introsequence)
{
    global.t += delta_time / 10000;
}

if(hitstop)
{
    room_speed = hitstop
    hitstop = 0
    global.hitstop = 0
}
if(global.hitstop)
{
    hitstop = room_speed
    room_speed /= global.hitstop
}
