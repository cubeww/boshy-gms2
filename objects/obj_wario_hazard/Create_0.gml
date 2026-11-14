enum WarioHazard {
    RisingSpike,
    RunningWario,
    WaveUp,
    WaveDown,
    HomingFish,
    SmallSpike
}

kind = WarioHazard.SmallSpike;
activated = false;
run_steps = 0;
drift_x = 0;
drift_y = 0;

configure = function(_kind) {
    kind = _kind;
    switch (kind) {
        case WarioHazard.RisingSpike:
        case WarioHazard.WaveUp:
        case WarioHazard.WaveDown:
            sprite_index = spr_wario_moving_spike;
            break;
        case WarioHazard.RunningWario:
            sprite_index = spr_wario_running_wario;
            break;
        case WarioHazard.HomingFish:
            sprite_index = spr_wario_homing_fish;
            break;
        case WarioHazard.SmallSpike:
            sprite_index = spr_wario_small_spike;
            break;
    }
    image_speed = 1;
};

advance = function(_player, _steps) {
    switch (kind) {
        case WarioHazard.RisingSpike:
            // Groups 692–693 raise the full row after the player reaches the save block above it.
            if (!activated && _player != noone && point_in_rectangle(_player.x, _player.y, 129, 514, 160, 545)) {
                activated = true;
            }
            if (activated) {
                y -= 5;
            }
            break;
        case WarioHazard.RunningWario:
            // Groups 694–697 send Wario across the bridge and then up a stepped slope.
            if (!activated && _player != noone && point_in_rectangle(_player.x, _player.y, 102, -154, 120, 197)) {
                activated = true;
            }
            if (activated) {
                // Group 696 evaluates its one-second timer only after activation.
                ++run_steps;
                x += 3 + (run_steps mod 50 == 0);
            }
            if (x >= 1122) {
                x -= 15;
                y -= 8;
            }
            break;
        case WarioHazard.WaveUp:
            y = floor(ystart + dsin((_steps * 20) div 4) * 18);
            break;
        case WarioHazard.WaveDown:
            y = floor(ystart - dsin((_steps * 20) div 4) * 18);
            break;
        case WarioHazard.HomingFish:
            // Groups 717–724 steer toward the player only while the chase zone is occupied.
            if (_player != noone && point_in_rectangle(_player.x, _player.y, 1291, 1, 1966, 491)) {
                drift_x += sign(_player.x - x) * 0.1;
                drift_y += sign(_player.y - y) * 0.1;
                x = floor(x + drift_x);
                y = floor(y + drift_y);
                drift_x = clamp(drift_x, -2, 2);
                drift_y = clamp(drift_y, -2, 2);
            }
            break;
    }
};
