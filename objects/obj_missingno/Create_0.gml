game_controller = instance_find(obj_game, 0);
var _difficulty = game_campaign_difficulty();
if (_difficulty < 0) {
    _difficulty = 1;
}
var _health = [50, 100, 100, 200];
var _meters = [75, 100, 100, 300];
max_health = _health[_difficulty];
health_meter_max = _meters[_difficulty];
hit_points = max_health;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");

fight_age = 140;
scene_steps = 0;
attempt_steps = 0;
timer_reset_second = -1;
hud_opacity = 0;
enemy_level_up = false;
death_age = 0;
hit_flash_age = 0;
target_x = -100;
target_y = 123;
shake_strength = 0;
shake_x = 0;
shake_y = 0;
blur_strength = 0;
read_sign = "";
read_sign_steps = 0;
intro_cry = -1;

set_read_sign = function(_text) {
    read_sign = _text;
    read_sign_steps = 0;
};

set_screen_blur = function(_strength) {
    blur_strength = _strength;
};

reset_boss_timer = function() {
    // Reset the displayed seconds while retaining the room-wide one-second pulse.
    timer_reset_second = scene_steps div 50;
    attempt_steps = 0;
};

start_battle_music = function() {
    var _cd = ninja_gaiden_selected_cd();
    if (is_undefined(_cd)) {
        game_controller.start_stage_music(snd_ninja_gaiden_boss_exit_music);
    } else {
        game_controller.start_stage_music(_cd[2], true, true, _cd[3]);
    }
};

take_player_shot = function(_shot) {
    if (_shot.reflected || hit_points <= 0) {
        return false;
    }
    if (fight_age > 400 && visible) {
        var _boss = id;
        var _hit = false;
        with (_shot) {
            _hit = place_meeting(x, y, _boss);
        }
        if (_hit) {
            // G707–708 take one hit from either the regular bullet or Rattata's shot.
            --hit_points;
            audio_play_sound(snd_mario_bump, 1, false);
            if (hit_flash_age == 0) {
                hit_flash_age = 1;
            }
            return true;
        }
    }
    return _shot.object_index == obj_bullet && missingno_guard_take_shot(_shot);
};

missingno_pose_setup();
missingno_attacks_setup();
missingno_victory_setup();
