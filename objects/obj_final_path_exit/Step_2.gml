var _player = instance_find(obj_player, 0);
if (_player != noone && !_player.dead) {
    var _door = instance_find(obj_final_path_exit_door, 0);
    if (_door != noone && _player.boshy_mask_meeting(_door)) {
        finish_solgryn_exit(false);
        exit;
    }

    // G902 releases all 13 authored floor tiles on the same step.
    if (_player.x >= 5865 && _player.x < 6005 && _player.y >= 6499 && _player.y < 7052) {
        bridge_released = true;
    }
}

if (bridge_released && instance_exists(obj_final_path_exit_bridge_tile)) {
    with (obj_final_path_exit_bridge_tile) {
        y += floor(fall_speed);
        fall_speed += 0.1 + irandom(109) * 0.01;
        image_angle += irandom_range(1, 3);
        if (bbox_top >= room_height) {
            instance_destroy();
        }
    }
    // G903 raises the shared center once before G904 evaluates the next orbit position.
    orbit_center_y -= 6.5;
}

orbit_angle = (orbit_angle + 5) mod 360;
x = floor(orbit_center_x + dcos(orbit_angle) * 25);
y = floor(orbit_center_y - dsin(orbit_angle) * 25);

if (teleport_age == -1 && _player != noone && !_player.dead && _player.boshy_mask_meeting(id)) {
    teleport_age = 0;
    // G906 and the G600 fast loop both play the same cue on contact.
    repeat (2) {
        array_push(teleport_sounds, audio_play_sound(snd_tutorial_teleport, 1, false));
    }
}
if (teleport_age >= 50) {
    finish_solgryn_exit(true);
    exit;
} else if (teleport_age >= 0) {
    // G908 chooses a new near-vertical blur angle on every active step.
    teleport_angle = 90 + irandom(29) - irandom(29);
    ++teleport_age;
}

// G909 sets X after the overlap and angle update, bypassing the horizontal orbit.
if (_player != noone && _player.x >= 5583) {
    x = _player.x - 100;
}
