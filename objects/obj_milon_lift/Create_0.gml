vertical_step = 1;
touching_backdrop = false;
image_speed = 0;

milon_rider_probe_overlaps = function(_player_x, _player_y) {
    // Active 23 is a 16 x 16 mask with its hotspot at (7, 13).
    var _x = floor(_player_x);
    var _y = floor(_player_y);
    return collision_rectangle(_x - 7, _y - 13, _x + 8, _y + 2, id, true, false) != noone;
};
