depth = -15000

// screen transition stuff
w = display_get_gui_width();
h = display_get_gui_height();
h_half = h * 0.5;
w_half = w * 0.5;
enum TRANS_MODE
{
    OFF,
    NEXT,
    GOTO,
    DIRECT,
    RESTART,
    SOFTRESTART,
    ACTIVE,
    ACTIVE2
};
enum TRANS_TYPE
{
    NONE,
    BOX,
    SLOW_HORIZONTAL
};
mode = TRANS_MODE.ACTIVE;
transtype = TRANS_TYPE.BOX;
percent = 1;
trans_speed = 5; //INVERSE!! LOWER IS FASTER!!!! DUHH APE BRAIN
target = room;

// player control
controltimer = 0

// global variables
global.snd_volume = 1
global.bgm_volume = 1
global.rich_presence = 0
global.speedrun_mode = false
global.t = 0
global.controller = false
global.hasgun = true
global.cutscene = false
global.introsequence = false
global.gamestarted = false
global.pausetimer = false
global.gunlesspercent = false
global.playerhealth = 0
global.playermaxhealth = 0
global.animemode = false
global.checkpointx = -1
global.checkpointy = -1
global.bonehive_started = 0
global.loading_rm = noone
global.loading_txt = ""
global.hitstop = 0; hitstop = 0
global.player = noone

// boss
currentboss = noone
drawbossbar = 0

// music
current_bgm = noone;

bgm_bus = audio_bus_create();

lowpasseffect = audio_effect_create(AudioEffectType.LPF2)
lowpasseffect.cutoff = 400
lowpasseffect.q = 2
bgm_bus.effects[0] = lowpasseffect

bgm_emitter = audio_emitter_create();
audio_emitter_bus(bgm_emitter, bgm_bus);
// example method of playing sounds: audio_play_sound_on(bgm_emitter, snd_Ambience, true, 100);

audio_listener_orientation(0, 0, 1, 0, -1, 0)

// rmm
current_st = -1;
target_st = 0;
target_rm = 0;

stages =
[
    [lvl1_0],
    [lvl1_1, lvl1_2, lvl1_3, lvl1_4],
    [lvl2_0],
    [lvl3_0]
]

stage_tips =
[
    "",
    "idk",
    "once I establish my theocracy.. I will throw you into my DUNGEON, and you will rot for ETERNIT-",
    "uh oh"
]

// THE RM_LIST IS FUCKING DEAD FUCK YOU RM_LIST GOODBYE

save_st = function()
{
    ini_open("save.ini");
    ini_write_real("savedata", "stage", current_st);
    ini_close();
    console_log("saved (" + string(current_st) + ")");
}

// settings
ini_open("save.ini");

global.snd_volume = ini_read_real("settings", "sound_volume", 0.5);
global.bgm_volume = ini_read_real("settings", "music_volume", 0.8);
audio_group_set_gain(audiogroup_default, global.snd_volume, 0);
audio_group_set_gain(audiogroup_bgm, global.bgm_volume, 0);

global.speedrun_mode = ini_read_real("settings", "speedrun_mode", 1);

global.rich_presence = ini_read_real("settings", "rich_presence", 0);

global.fx_bias = ini_read_real("settings", "fx_bias", 0);

ini_close();

// commands
global.console = false;
input_str = "";
last_input_str = "";
log_str = "";
log_pos = 0;
cursor_timer = 0;

// start up discord rich presence
if(global.rich_presence)
    neko = instance_create_depth(x, y, 0, objNekoPresenceDemo)
