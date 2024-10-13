function GetRoom(_room)
{
    with(gm)
    {
        var rm_i = 0;
        for(i = 0; i < array_length(stages); i++)
        {
            for(j = 0; j < array_length(stages[i]); j++)
            {
                if(rm_list[rm_i] == _room)
                {
                    return rm_list[rm_i];
                    break;
                }
                else rm_i++;
            }
        }
        return -1;
    }
}
function GetStage(_room)
{
    with(gm)
    {
        var rm_i = 0;
        for(var i = 0; i < array_length(stages); i++)
        {
            for(var j = 0; j < array_length(stages[i]); j++)
            {
                if(rm_list[rm_i] == _room)
                {
                    return i;
                    break;
                }
                else rm_i++;
            }
        }
        return -1;
    }
}
