var _player = instance_find(obj_player, 0);
if (_player == noone || _player.dead) {
    exit;
}

// G804–805 slide the channel portrait when the player approaches it.
if (point_in_rectangle(_player.x, _player.y, 259, 2867, 294, 3092)) {
    slide_started = true;
}
if (slide_started) {
    x += slide_speed;
    slide_speed += 2;
}

// The portrait belongs to both the solid and hazard qualifiers.
if (_player.boshy_mask_meeting(id)) {
    _player.die();
}
