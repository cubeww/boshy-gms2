++scene_steps;
var _player = instance_find(obj_player, 0);

// G639 uses the offsets saved by the preceding frame for the whole scene.
if (_player != noone) {
    camera_set_view_pos(view_camera[0], -1 + shake_x, -2 + shake_y);
}
if (shake_strength > 0) {
    // G784 decrements before selecting the next pair of shake offsets.
    shake_strength = max(0, floor(shake_strength) - 1);
    shake_x = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
    shake_y = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
}

if (arrival_age >= 0) {
    var _frames = sprite_get_number(spr_tutorial_portal_transition);
    var _progress = floor(++arrival_age * 0.6);
    if (_progress >= _frames) {
        arrival_age = -1;
        game_controller.teleport_mosaic_columns = 0;
        game_controller.teleport_mosaic_rows = 0;
    } else {
        var _grid_size = _progress * 31;
        game_controller.teleport_mosaic_columns = _grid_size;
        game_controller.teleport_mosaic_rows = _grid_size;
    }
}

bomberman_pose_step();
if (hit_points > 0) {
    ++fight_age;
    bomberman_attacks_step(_player);
} else if (victory_age < 0) {
    bomberman_victory_begin();
} else {
    bomberman_victory_step(_player);
}

// Native body contact depends on visibility, including during the defeat animation.
if (_player != noone && visible && _player.boshy_mask_meeting(id) && _player.die()) {
    _player = noone;
}
if (hit_flash_age > 0 && ++hit_flash_age >= 10) {
    hit_flash_age = 0;
}
bomberman_ordnance_step(_player);
bomberman_pose_trail_step();

if (_player == noone) {
    game_controller.fade_stage_music();
}
