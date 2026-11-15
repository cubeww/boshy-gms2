game_controller = instance_find(obj_game, 0);
var _difficulty = game_campaign_difficulty();
if (_difficulty < 0) {
    _difficulty = 1;
}
var _health_by_difficulty = [45, 105, 105, 200];
var _phase_thresholds = [35, 90, 90, 180];
max_health = _health_by_difficulty[_difficulty];
hit_points = max_health;
phase_threshold = _phase_thresholds[_difficulty];
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");

fight_age = -50;
fight_phase_two = false;
scene_steps = 0;
motion_x = 0;
motion_y = 0;
chase_x = 0;
chase_y = 0;
floor_contact = false;
shake_strength = 0;
shake_x = 0;
shake_y = 0;
hit_flash_age = 0;
death_voice = -1;

image_speed = 0;
facing = 1;
pose_animation = 0;
pose_speed = 100;
pose_counter = 0;
pose_repeat = 0;
pose_loop_start = 0;

sanicz_set_pose = function(_animation, _facing = 0) {
    var _direction = _facing == 0 ? facing : _facing;
    if (_animation == pose_animation && _direction == facing) {
        return;
    }
    var _frame = image_index;
    if (_animation != pose_animation) {
        _frame = 0;
        pose_counter = 0;
    }
    pose_animation = _animation;
    facing = _direction;
    pose_repeat = 0;
    pose_loop_start = 0;
    switch (_animation) {
        case 12:
            sprite_index = facing < 0 ? spr_sanicz_anim_12_left : spr_sanicz_anim_12;
            pose_speed = 50;
            pose_loop_start = 6;
            break;
        case 13:
            sprite_index = spr_sanicz_anim_13;
            pose_speed = 80;
            pose_repeat = 80;
            pose_loop_start = 24;
            break;
        case 14:
            sprite_index = facing < 0 ? spr_sanicz_anim_14_left : spr_sanicz_anim_14;
            pose_speed = 50;
            break;
        case 15:
            sprite_index = spr_sanicz_hurt;
            pose_speed = 0;
            break;
        default:
            sprite_index = facing < 0 ? spr_sanicz_idle_left : spr_sanicz_idle;
            pose_speed = facing < 0 ? 50 : 100;
            break;
    }
    image_index = _frame < image_number ? _frame : 0;
};

sanicz_advance_pose = function() {
    pose_counter += pose_speed;
    if (pose_counter <= 100) {
        return;
    }
    pose_counter -= 100;
    if (image_index + 1 < image_number) {
        ++image_index;
        return;
    }
    if (pose_repeat > 0 && --pose_repeat == 0) {
        sanicz_set_pose(0);
        return;
    }
    image_index = pose_loop_start;
};

// Return true when the shot is consumed. Reflections retain the shot's owner.
take_player_shot = function(_bullet) {
    if (victory_age >= 0 || _bullet.reflected) {
        return false;
    }
    var _boss = id;
    var _hit = false;
    with (_bullet) {
        _hit = place_meeting(x, y, _boss);
    }
    if (!_hit) {
        return false;
    }
    // G1194 consumes a hit at 3520 before G1195 can reflect it.
    if (fight_age > 3520) {
        _bullet.reflected = true;
        _bullet.reflection_angle = irandom_range(12, 14) * 11.25;
        audio_play_sound(snd_green_greens_middle_reflect, 1, false);
        return false;
    }
    take_hit(1);
    return true;
};

take_hit = function(_damage) {
    if (hit_flash_age == 0) {
        hit_flash_age = 1;
    }
    audio_play_sound(snd_mario_bump, 1, false);
    hit_points = max(0, hit_points - _damage);
    if (hit_points == 0) {
        sanicz_victory_begin(game_controller.frame_seconds);
    }
};

sanicz_draw_hud = function(_viewport) {
    var _scale = _viewport.width / game_controller.render_width;
    var _left = _viewport.left;
    var _top = _viewport.top;
    if (hit_points > 0) {
        var _width = floor(639 * hit_points / max_health) * _scale;
        draw_rectangle_color(_left, _top, _left + _width, _top + 9 * _scale, c_white, c_white, c_white, c_white, false);
    }
    sanicz_victory_draw_hud(_viewport);
};

sanicz_attacks_setup();
sanicz_victory_setup();
if (game_selected_cd() == 0) {
    game_controller.start_stage_music(snd_sanicz_intro_music, false, false, 48000);
}
