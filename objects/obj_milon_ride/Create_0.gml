base_y = 835;
mounted = false;
ride_speed = 0;
vertical_mode = 0;
vertical_steps = 0;
image_speed = 0;

advance_milon_ride = function(_player, _stage_steps) {
    // G702–705 bob about the current flight height and board on player overlap.
    y = floor(base_y + dsin((_stage_steps * 20) div 3) * 4);
    if (_player != noone && !mounted && !_player.input_locked && _player.boshy_mask_meeting(id)) {
        mounted = true;
        _player.visible = false;
    }
    if (!mounted) {
        return;
    }

    if (_player != noone) {
        // Fusion G46 tests hazards after regular player movement, before G704 attaches the rider.
        _player.x = x;
        _player.y = y;
        _player.facing = 1;
        _player.refresh_collision_probes();
    }
    x += ride_speed;
    ride_speed = min(8, ride_speed + 1);

    // G706–711 use Jump and Down to change the bobbing height for 15 steps.
    if (keyboard_check_pressed(global.settings.keys.jump) && vertical_mode != -1) {
        vertical_mode = -1;
        vertical_steps = 0;
    }
    if (keyboard_check_pressed(global.settings.keys.down) && vertical_mode != 1) {
        vertical_mode = 1;
        vertical_steps = 0;
    }
    if (vertical_mode < 0) {
        ++vertical_steps;
        base_y = 800;
    }
    if (vertical_steps >= 15) {
        vertical_mode = 0;
        vertical_steps = 0;
    }
    if (vertical_mode > 0) {
        ++vertical_steps;
        base_y = 870;
    } else if (vertical_mode == 0) {
        base_y = 835;
    }

    if (x > 4600) {
        // G712–713 release the player on reaching the bridge.
        if (_player != noone) {
            _player.visible = true;
        }
        instance_destroy();
    }
};
