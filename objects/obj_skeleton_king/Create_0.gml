game_controller = instance_find(obj_game, 0);
var _difficulty = game_campaign_difficulty();
if (_difficulty < 0) {
    _difficulty = 1;
}
var _health_by_difficulty = [80, 160, 160, 320];
max_health = _health_by_difficulty[_difficulty];
// The Scouter reads the authored King HP until G69–71 start the fight.
hit_points = 160;
easy_mode = _difficulty == 0;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");

scene_steps = 0;
attempt_steps = 0;
king_started = false;
king_age = -1;
king_defeated = false;
king_defeat_steps = 0;
king_defeat_explosions = 0;
king_explosions = [];
king_detached_parts = [];
king_talk_age = -1;
king_body_idle_steps = 0;
king_velocity_y = 0;
hit_flash_age = 0;
intro_alpha = 1 - 15 / 128;
shake_strength = 0;
shake_x = 0;
shake_y = 0;
blur_strength = 0;
page_left = 0;
page_top = 0;

king_legs_angle = 0;
king_body_angle = 0;
king_left_angle = 0;
king_right_angle = 0;
king_body_x = x;
king_body_y = y + 10;
king_left_x = king_body_x - 48;
king_left_y = king_body_y - 71;
king_right_x = king_body_x + 49;
king_right_y = king_body_y - 76;
king_body_sprite = spr_skeleton_king_body_left;
king_body_frame = 0;
king_left_frame = 0;

blob_age = -1;
blob_x = 2144;
blob_y = -160;
blob_velocity_y = 0;
blob_pose = spr_skeleton_king_blob_left;
blob_pose_steps = 0;
blob_visible = false;
blob_arm_active = false;
blob_arm_angle = 0;
blob_arm_speed = 0;
blob_arm_turns = 0;
blob_arm_exit_steps = 0;
blob_chat_age = -1;
blob_chat_letters = 0;
blob_chat_x = 0;
blob_chat_y = 0;
blob_flyer = noone;
victory_trophy_wait = -1;
victory_trophy_age = -1;
victory_trophy_title = ["", ""];

king_body_mask = instance_create_depth(king_body_x, king_body_y, depth, obj_skeleton_king_pose);
skeleton_king_update_body_mask();
blob_mask = instance_create_depth(blob_x, blob_y, depth, obj_skeleton_king_pose);
blob_arm_mask = instance_create_depth(2006, 480, depth, obj_skeleton_king_pose);

take_player_shot = function(_shot) {
    if (_shot.reflected || !king_started) {
        return false;
    }
    if (!king_defeated && king_age >= 280 && skeleton_king_shot_overlaps(_shot, king_body_mask)) {
        skeleton_king_damage(1);
        return true;
    }
    // G796 reacts to a new bullet contact and leaves the bullet alive.
    if (blob_visible && _shot.object_index == obj_bullet && skeleton_king_shot_overlaps(_shot, blob_mask)) {
        var _new_contact = _shot.skeleton_king_blob_contact_step < scene_steps - 1;
        _shot.skeleton_king_blob_contact_step = scene_steps;
        if (_new_contact && blob_age >= 250 && blob_age < 1500) {
            blob_age = 300;
            game_controller.start_stage_music(snd_skeleton_king_blob_music, true, false);
        }
    }
    return false;
};

skeleton_king_draw_hud = function(_viewport) {
    var _scale = _viewport.width / game_controller.render_width;
    var _left = _viewport.left;
    var _top = _viewport.top;
    var _health_max = king_started || max_health != 160 ? max_health : 100;
    if (hit_points > 0) {
        var _width = floor(639 * min(hit_points, _health_max) / _health_max) * _scale;
        var _previous_alpha = draw_get_alpha();
        draw_set_alpha(1);
        draw_rectangle_color(_left, _top, _left + _width, _top + 9 * _scale,
            c_white, c_white, c_white, c_white, false);
        draw_set_alpha(_previous_alpha);
    }

    var _text_y = 16;
    if (show_boss_health) {
        var _health = string(hit_points) + " / " + string(_health_max);
        draw_boshy_text(_health, _left + (640 - string_length(_health) * 8) * _scale,
            _top + _text_y * _scale, 1, _scale);
        _text_y += 12;
    }
    if (show_boss_timer) {
        var _time = string(attempt_steps div 50) + " seconds";
        draw_boshy_text(_time, _left + (640 - string_length(_time) * 8) * _scale,
            _top + _text_y * _scale, 1, _scale);
    }
    if (victory_trophy_age >= 0) {
        var _alpha = 1 - max(0, victory_trophy_age - 200) / 26;
        draw_sprite_ext(spr_tutorial_achievement_banner, 0, _left + 434 * _scale, _top + 7 * _scale,
            _scale, _scale, 0, c_white, _alpha);
        draw_sprite_ext(spr_trophy_icon, 1, _left + 438 * _scale, _top + 12 * _scale,
            0.5 * _scale, 0.5 * _scale, 0, c_white, _alpha);
        var _first_line = victory_trophy_title[0];
        var _second_line = victory_trophy_title[1];
        var _first_length = string_length(_first_line);
        draw_boshy_text(string_copy(_first_line, 1, victory_trophy_age),
            _left + (628 - _first_length * 8) * _scale, _top + 17 * _scale, _alpha, _scale);
        draw_boshy_text(string_copy(_second_line, 1, max(0, victory_trophy_age - _first_length)),
            _left + (628 - string_length(_second_line) * 8) * _scale, _top + 29 * _scale, _alpha, _scale);
    }
};

skeleton_king_attacks_setup();
skeleton_king_set_view(instance_find(obj_player, 0));
