triggered = 1;

with (obj_player)
{
    hascontrol = false;
}
with (gm)
{
    gm_room_transition_goto(other.target_st, other.target_rm, TRANS_TYPE.BOX);
}

instance_destroy();
