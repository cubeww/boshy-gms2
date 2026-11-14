++scene_steps;
var _player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
    if (death_voice == -1) {
        death_voice = audio_play_sound(snd_sanicz_voice_31, 1, false);
    }
}

// The viewport consumes the previous offsets before the shaker computes new ones.
if (_player != noone) {
    sanicz_arena_set_view(shake_x, shake_y);
}
if (shake_strength > 0) {
    --shake_strength;
    shake_x = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
    shake_y = shake_strength > 0 ? irandom_range(-shake_strength, shake_strength - 1) : 0;
}

if (sprite_index >= 0) {
    sanicz_advance_pose();
}
if (victory_age < 0) {
    if (_player != noone) {
        ++attempt_steps;
        ++fight_age;
        sanicz_movement_step(_player);
    } else {
        // G1119 parks the attack counter after the player is destroyed.
        fight_age = -100;
    }
    sanicz_attacks_step(_player);
} else {
    sanicz_victory_step();
}
sanicz_cameo_step();
if (victory_age < 0 && fight_age == 3760) {
    // Group 1201 restores the chase after this step's plane and ring updates.
    fight_age = 949;
    audio_play_sound(snd_sanicz_show_you, 1, false);
    sanicz_set_pose(14);
}
sanicz_bumpers_step(_player);
sanicz_ambient_step();

if (hit_flash_age > 0 && ++hit_flash_age >= 10) {
    hit_flash_age = 0;
}
