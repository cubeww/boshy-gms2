game_controller = instance_find(obj_game, 0);
phase_one = inst_cheetah_men_phase_1;
phase_two = inst_cheetah_men_phase_2;
phase_three = inst_cheetah_men_phase_3;
phase_one.restore_actor(phase_one.x, phase_one.y);
phase_two.restore_actor(phase_two.x, phase_two.y);
phase_three.restore_actor(phase_three.x, phase_three.y);
phase_two.actor_active = false;
phase_three.actor_active = false;

var _difficulty = game_campaign_difficulty();
var _health = [75, 150, 150, 300];
max_health = _health[_difficulty < 0 ? 1 : _difficulty];
hit_points = max_health;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");
hud_max_health = 200;
trigger_finger_age = -1;
encounter_steps = 0;
fight_age = 0;
attack_clock = 0;
spiral_direction = 0;
phase_two_jump_age = 0;
phase_two_move_left = false;
phase_two_platform_age = 0;
phase_three_hits = 0;
phase_three_break_floor = true;
phase_three_hazard_clock = 0;
phase_three_slide_clock = 0;
hit_flash_age = -1;
phase_one_cleared = false;
phase_clear_sound = -1;
phase_two_hit_sound = -1;
phase_three_jingle = -1;
shake_strength = 0;
page_left = 0;
page_top = 0;

update_view = function(_player) {
    camera_set_view_size(view_camera[0], 640, 481);
    camera_set_view_pos(view_camera[0], -1, -2);
    var _pickup_age = fight_age >= 6850 ? inst_cheetah_men_reward.pickup_age : -1;
    chest_view_update(game_controller, _player, _pickup_age);
    shake_strength = max(0, shake_strength - 1);
    game_controller.scene_shake_x = shake_strength > 0 ? irandom(2 * shake_strength - 1) - shake_strength : 0;
    game_controller.scene_shake_y = shake_strength > 0 ? irandom(2 * shake_strength - 1) - shake_strength : 0;
};

pause_for_phase_clear = function() {
    audio_pause_sound(game_controller.stage_music_instance);
    phase_clear_sound = audio_play_sound(snd_cheetah_men_phase_clear, 1, false);
};

shot_hits_actor = function(_shot, _actor) {
    if (!_actor.actor_active) {
        return false;
    }
    var _hit = false;
    with (_shot) {
        _hit = place_meeting(x, y, _actor);
    }
    return _hit;
};

take_player_shot = function(_shot) {
    if (_shot.reflected || fight_age >= 6000) {
        return false;
    }
    if (cheetah_men_attacks_take_shot(_shot)) {
        return true;
    }
    if (fight_age >= 4610 && fight_age <= 5250 && shot_hits_actor(_shot, phase_two)) {
        // G1234–35 decrement the giant's private health even though the Scouter reads another value.
        // Both ordinary and Gastly hits replace the explosion on Fusion's channel 26.
        if (phase_two_hit_sound != -1 && audio_is_playing(phase_two_hit_sound)) {
            audio_stop_sound(phase_two_hit_sound);
        }
        phase_two_hit_sound = audio_play_sound(snd_cheetah_men_phase_clear, 1, false, 1, 0,
            (44000 + irandom(19999) - irandom(9999)) / 44100);
        if (hit_flash_age < 0) {
            hit_flash_age = 0;
        }
        --hit_points;
        if (hit_points <= 0) {
            fight_age = 6000;
            audio_stop_sound(game_controller.stage_music_instance);
            game_controller.stage_music_instance = -1;
        }
        return true;
    }
    if (shot_hits_actor(_shot, phase_three)) {
        // G1183 absorbs Gastly shots without advancing this stage's 50 regular hits.
        if (_shot.object_index == obj_bullet) {
            ++phase_three_hits;
        }
        audio_play_sound(snd_mario_bump, 1, false);
        return true;
    }
    if (shot_hits_actor(_shot, phase_one) || (fight_age <= 4610 && shot_hits_actor(_shot, phase_two))) {
        // G1143–48 use the native direction mask 14336 (directions 11, 12 and 13).
        _shot.reflected = true;
        _shot.reflection_angle = irandom_range(11, 13) * 11.25;
        audio_play_sound(snd_cheetah_men_reflect, 1, false);
    }
    return false;
};

// G1093 always restarts the theme at the beginning of a new fight.
game_controller.start_stage_music(snd_cheetah_men_theme, true, false);
update_view(instance_find(obj_player, 0));
