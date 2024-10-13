function SlideTransition(_mode, _type = TRANS_TYPE.BOX, _target = room)
{
	with (gm)
	{
		mode = _mode;
		transtype = _type;
		target = _target;
	}
}

function gm_room_transition_goto(st, rm, transition_type = TRANS_TYPE.BOX)
{
	with (gm)
	{
		mode = TRANS_MODE.GOTO;
		transtype = transition_type;
		target = stages[st][rm];
		target_st = st;
		target_rm = rm;
	}
}

function gm_room_transition_direct(target_room, transition_type = TRANS_TYPE.BOX)
{
	with (gm)
	{
		mode = TRANS_MODE.DIRECT;
		transtype = transition_type;
		target = target_room;
	}
}

function gm_room_transition_restart(transition_type = TRANS_TYPE.BOX)
{
	with (gm)
	{
		mode = TRANS_MODE.RESTART;
		transtype = transition_type;
	}
}
