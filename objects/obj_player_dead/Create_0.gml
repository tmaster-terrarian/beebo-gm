move = 0;
hsp = 0;
vsp = 0;
grv = 0.05;
done = false;
oob = false;

textchar = 0
lastchar = 0
txt = ""

image_speed = 0
image_index = 0

explosiontimer = 80;
timer_finished = false;

alarm[0] = 80;

shake_length = 999999999;
shake_magnitude = 3;
shake_remain = 3;

cam = view_camera[0];
with(oCamera) target = other.id;

rm = room;
bg = instance_create_depth(0, 0, 752, obj_death_bg);

with(gm) audio_sound_gain(current_bgm, 0, 0);
var sound = audio_play_sound(sn_slowmo, 2, false);

with(oCamera) if(follow == obj_player) follow = other;

global.pausetimer = true;
