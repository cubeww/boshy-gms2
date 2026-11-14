// The four source frames share pixels and differ only in their vertical hotspots.
bob_offsets = [0, 1, 0, -1];

refresh_player = function(_player) {
    if (!visible) {
        return;
    }

    _player.air_jump_available = true;
    visible = false;
    alarm[0] = 80;
};
