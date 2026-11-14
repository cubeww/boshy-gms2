if (active_steps < 0) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && !_player.dead
        && _player.x >= trigger_left && _player.x < trigger_right
        && _player.y >= trigger_top && _player.y < trigger_bottom) {
        active_steps = 0;
        y += 350;
        visible = true;
        waka_sound = audio_play_sound(snd_final_path_pacman_waka, 1, true);
    }
    exit;
}

// G865 keeps moving the actor while G871 adds the accelerating fall.
++active_steps;
x += 3;
--y;
if (active_steps == 900) {
    audio_stop_sound(waka_sound);
    waka_sound = -1;
} else if (active_steps > 900) {
    y += (active_steps - 900) div 2;
    image_angle = (image_angle - 3 + 360) mod 360;
}

// G867–869 use the current Pac-Man subimage to start crumbling each block.
var _pacman = id;
with (obj_final_path_breakable_block) {
    if (crumble_steps > 0 || place_meeting(x, y, _pacman)) {
        x -= 2;
        y -= 3;
        if (++crumble_steps == 6) {
            // Fusion creates all 16 particles at (0, 0) relative to the block.
            repeat (16) {
                instance_create_layer(x, y + 31, "Effects", obj_final_path_block_debris);
            }
            instance_destroy();
        }
    }
}
