vsp += grv;

//move and collisions
//horizontal
if (place_meeting(x + hsp, y, oWall))
{
    while (!place_meeting(x + sign(hsp), y, oWall))
    {
        x += sign(hsp);
    }
    hsp = -hsp;
}
x += hsp;

//vertical
if (place_meeting(x, y + vsp, oWall))
{
    while (!place_meeting(x, y + sign(vsp), oWall))
    {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

if (!place_meeting(x + sign(hsp), y + 1, oWall))
{
    hsp = -hsp;
}

//animation
if (!place_meeting(x, y + 1, oWall))
{
    sprite_index = sRoboA;
    image_speed = 0;
    if (sign(vsp) > 0) image_index = 1; else image_index = 0;
}
else
{
    image_speed = 1;
    if (hsp == 0)
    {
        sprite_index = sRobo;
    }
    else
    {
        sprite_index = sRoboR;
    }
}

if(hsp != 0) image_xscale = sign(hsp) * size;
image_yscale *= size;
