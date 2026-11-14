if (is_crusher) {
    // Groups 760–761 start the moving spike when the player enters the corridor.
    if (!crusher_started) {
        var _player = instance_find(obj_player, 0);
        crusher_started = _player != noone && point_in_rectangle(_player.x, _player.y, 1536, 373, 1764, 439);
    }
    if (crusher_started) {
        x += 3;
        if (x > room_width + 64) {
            instance_destroy();
        }
    }
    exit;
}

// Groups 848–851 phase the spike banks by each row's original Y position.
++elapsed_steps;
x = floor(xstart + dsin(elapsed_steps * 4 + ystart) * 25);
