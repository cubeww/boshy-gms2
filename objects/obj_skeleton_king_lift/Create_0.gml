// Active 31 is a full 16 x 18 mask with its hotspot at (7, 10).
rider_probe_overlaps = function(_player_x, _player_y) {
    var _x = floor(_player_x);
    var _y = floor(_player_y);
    return collision_rectangle(_x - 7, _y - 10, _x + 8, _y + 7, id, true, false) != noone;
};
