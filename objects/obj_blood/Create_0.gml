image_angle = irandom(359);
var _speed = irandom_range(4, 13);
hsp = lengthdir_x(_speed, image_angle);
vsp = lengthdir_y(_speed, image_angle);
fall_acceleration = irandom_range(20, 49) * 0.01;
settled = false;
image_speed = 0;
image_index = 0;
