audio_group_load(audiogroup_bgm);
random_set_seed(0);

started = 0;
anim_timer = 0; //200 frames is 3.33 seconds, right when the dos boots in the sound that plays. the entire sound is 1882.2 frames long
boot_sound = noone;

t_scale = 1;
t_pad_x = 1 + 36;
t_pad_y = 1;
t_line_size = 7;

random_dates = ["12/6/1985", "4/11/1986", "5/26/1986", "6/22/1986", "9/13/1987", "10/17/1988", "10/22/1988", "5/14/1989", "7/5/1989", "6/3/1990", "4/15/1991", "8/16/1991", "1/31/1992", "4/12/1992", "7/13/1992", "9/3/1992", "7/24/1993", "1/9/1994", "2/4/1994", "5/21/1994", "3/24/1995", "4/26/1995", "6/22/1995", "9/11/1995", "12/22/1995"];
_date = random_dates[floor(random_range(0, array_length(random_dates) - 1))];
_date = "7/23/1992";

ini_open("save.ini");

global.screenSize = clamp(floor(ini_read_real("settings", "res", 4)), 1, 7);
if(global.screenSize < 7)
{
    window_set_fullscreen(false);
    window_set_size((256 * global.screenSize), (144 * global.screenSize));
}
else
{
    window_set_fullscreen(true);
}

if(ini_read_real("savedata", "stage", 0) == 0)
{
    ini_key_delete("savedata", "stage");
}

ini_close();

window_center()
