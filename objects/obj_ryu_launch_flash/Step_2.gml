// Fusion G797–800 advance the accumulator using the previous angle, then re-aim and grow.
var _x = flash_x - frac(flash_x);
var _y = flash_y - frac(flash_y);
flash_x += lengthdir_x(2, image_angle);
flash_y += lengthdir_y(2, image_angle);

var _player = instance_find(obj_player, 0);
var _target_x = _player == noone ? 0 : _player.x;
var _target_y = _player == noone ? 0 : _player.y;
var _angle = darctan2(_x - _target_x, _y - _target_y) + 90 + irandom(59) - irandom(59);
image_angle = _angle - frac(_angle);
image_xscale += 0.031;
image_yscale = image_xscale;
if (image_xscale > 8) {
    instance_destroy();
    exit;
}

image_index = ((++flash_age * 30 - 1) div 100) mod 2;
// Frames 511–512 have hotspots two and three pixels right of the shared Hadoken origin.
var _offset = (2 + image_index) * image_xscale;
x = _x - lengthdir_x(_offset, image_angle);
y = _y - lengthdir_y(_offset, image_angle);
