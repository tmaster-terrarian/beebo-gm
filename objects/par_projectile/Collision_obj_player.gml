if(_team == team.neutral || _team == team.enemy)
{
	var _event = new damage_event(parent, other, proctype.onhit, damage, proc)

	oCamera.alarm[0] = 10
	instance_destroy()
}