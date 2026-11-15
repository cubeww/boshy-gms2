++encounter_steps;
++fight_age;
++attack_clock;
++phase_three_hazard_clock;
++phase_three_slide_clock;

if (trigger_finger_age >= 0 && ++trigger_finger_age >= 226) {
    trigger_finger_age = -1;
}
if (instance_number(obj_bullet) >= 5 && game_trophy_unlock("TriggerFinger")) {
    trigger_finger_age = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}

var _player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
}

if (fight_age < 6000) {
    cheetah_men_first_phase_step();
    cheetah_men_second_phase_step();
    cheetah_men_third_phase_step(_player);
    cheetah_men_transform_step(_player);
}

cheetah_men_ordnance_step(_player);
_player = instance_find(obj_player, 0);
cheetah_men_phase_three_hazards_step(_player, encounter_steps * 20);
_player = instance_find(obj_player, 0);
if (fight_age >= 6000) {
    cheetah_men_victory_step(_player);
}
if (_player != noone) {
    // G1242 retires the Cheetahs when the final explosion starts.
    with (obj_cheetah_men_actor) {
        if (actor_active && _player.boshy_mask_meeting(id) && _player.die()) {
            break;
        }
    }
}

if (hit_flash_age >= 0) {
    ++hit_flash_age;
    phase_two.invert_colors = hit_flash_age == 2 || hit_flash_age == 3
        || hit_flash_age == 6 || hit_flash_age == 7;
    if (hit_flash_age >= 10) {
        hit_flash_age = -1;
    }
}

// G1248 resumes the theme after the first two phase-clear clips finish.
if (phase_clear_sound != -1 && !audio_is_playing(phase_clear_sound)) {
    phase_clear_sound = -1;
    if (instance_exists(obj_player) && fight_age < 4000) {
        audio_resume_sound(game_controller.stage_music_instance);
    }
}

update_view(instance_find(obj_player, 0));
