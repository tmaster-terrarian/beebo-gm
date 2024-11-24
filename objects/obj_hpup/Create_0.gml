event_inherited();

hsp = random_range(-0.5, 0.5);
vsp = random_range(-2, -1);
grv = 0.075;

facing = 1

done = false;
bounce_counter = 0;
max_bounces = 2;
decel_rate = 0.25;

follow_player = false;

image_index = round(random_range(0, 8));
