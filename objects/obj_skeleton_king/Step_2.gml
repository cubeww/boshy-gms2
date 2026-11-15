++scene_steps;
var _player = instance_find(obj_player, 0);
// G47 checks the torso and arm before their later position events.
if (_player != noone && (_player.boshy_mask_meeting(king_body_mask)
    || (blob_arm_active && _player.boshy_mask_meeting(blob_arm_mask))) && _player.die()) {
    _player = noone;
}
if (_player != noone) {
    // G69–71 start the encounter when the player brings the torch into the arena.
    if (!king_started && _player.x >= 1280
        && instance_exists(inst_skeleton_king_torch) && inst_skeleton_king_torch.torch_attached) {
        king_started = true;
        hit_points = max_health;
        _player.x += 16;
        _player.refresh_collision_probes();
        inst_skeleton_king_gate.sprite_index = spr_ryu_arena_gate;
        inst_skeleton_king_gate.visible = true;
        inst_skeleton_king_torch.torch_dropped = true;
        inst_skeleton_king_torch.torch_fall_speed = -8;
    }
    skeleton_king_set_view(_player);
} else {
    game_controller.fade_stage_music();
}
with (obj_skeleton_king_torch) {
    skeleton_king_torch_step(_player);
}

if (king_started) {
    if (!king_defeated) {
        ++king_age;
        skeleton_king_body_step(_player);
    } else {
        skeleton_king_defeat_step();
        if (blob_age >= 0) {
            skeleton_king_blob_step(_player != noone);
        }
        skeleton_king_detached_parts_step();
    }
    // G817–818 fade the preplaced darkness once the arena closes.
    intro_alpha = max(0, intro_alpha - 1 / 128);
    if (intro_alpha <= 8 / 128) {
        intro_alpha = 0;
    }
} else {
    skeleton_king_pose_step();
    skeleton_king_update_body_mask();
}
if (blob_arm_active) {
    skeleton_king_blob_arm_step();
}
skeleton_king_blob_chat_step();
skeleton_king_attacks_step(_player);
if (!king_defeated && king_age == 2800) {
    king_age = 10;
    audio_play_sound(snd_skeleton_king_lair, 1, false);
}
if (hit_flash_age > 0 && ++hit_flash_age >= 10) {
    hit_flash_age = 0;
}
skeleton_king_trophy_step();

// G948 sets the offsets for the next camera pass.
if (shake_strength > 0) {
    --shake_strength;
    shake_x = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
    shake_y = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
}

// G1030 decays the blur and chooses a new direction each step.
if (blur_strength > 0) {
    blur_strength *= 0.9;
    if (blur_strength < 0.001) {
        blur_strength = 0;
    }
    var _blur_angle = irandom(359);
    game_controller.directional_blur_x = dcos(_blur_angle) * blur_strength * 0.01;
    game_controller.directional_blur_y = dsin(_blur_angle) * blur_strength * 0.01;
}
