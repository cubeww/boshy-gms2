// Fusion G748–752 fires from the previous position before updating the wave path.
++cycle_step;
++shot_cooldown;
wave_phase += 4;
stage_time += 20;
var _player = instance_find(obj_player, 0);
if (_player != noone && cycle_step >= 15) {
    if (_player.y < 2665 && shot_cooldown >= 2) {
        instance_create_depth(x, y, depth - 1, obj_milon_depth_wave_shot, {
            travel_direction: -1, travel_speed: 3
        });
        image_index = 1;
        shot_cooldown = 0;
    }
    if (_player.y >= 2665 && shot_cooldown >= 12) {
        instance_create_depth(x, y, depth - 1, obj_milon_depth_wave_shot, {
            travel_direction: 1, travel_speed: 1 + abs(dsin(stage_time) * 3)
        });
        sprite_index = spr_milon_depth_wave_shooter;
        image_index = 1;
        shot_cooldown = 0;
    }
}
flash_timer -= 20;
if (flash_timer <= 0) {
    flash_timer += 150;
    image_index = 0;
}
if (cycle_step >= 40) {
    cycle_step = 0;
}

if (_player == noone) {
    exit;
}

// G753–755 each use the previous wave center before setting the next one.
if (_player.y <= 2550) {
    y = floor(wave_center_y + dsin(wave_phase * 5) * 8);
    wave_center_y = 2490;
    x = xstart;
}
if (_player.y >= 2550 && _player.y < 2665) {
    y = floor(wave_center_y + dsin(wave_phase * 2.5) * 48);
    wave_center_y = 2580;
    x = xstart;
}
if (_player.y >= 2665) {
    x = 32;
    y = floor(wave_center_y + dsin(wave_phase * 5) * 48);
    wave_center_y = 2730;

    // G756 clears the current waves and replaces the shooter with its disappearance animation.
    if (_player.x < 130) {
        with (obj_milon_depth_wave_shot) {
            instance_destroy();
        }
        instance_create_depth(x, y, depth, obj_milon_depth_wave_puff);
        instance_destroy();
    }
}
