game_controller = instance_find(obj_game, 0);
difficulty = game_campaign_difficulty();
if (difficulty < 0) {
    difficulty = 1;
}
var _health_by_difficulty = [75, 150, 150, 300];
max_health = _health_by_difficulty[difficulty];
hit_points = max_health;
scene_steps = 0;
fight_age = -1;
attempt_steps = 0;
hit_flash_age = -1;
shake_strength = 0;
blur_strength = 0;
arena_flash = 0;
dialogue_lines = [];
dialogue_steps = 0;
dialogue_letters = 0;
dialogue_length = 0;
intro_marker_y = -13;
defeated = false;
victory_age = 0;
defeat_bounces = 0;
defeat_hsp = -1;
defeat_vsp = -3;
dance_active = false;
dance_x = 1600;
dance_y = 438;
dance_sound = -1;
exit_ready = false;
view_page_left = 0;
view_width = 640;
view_center_x = 320;
view_center_y = 240;
trophy_titles = [];
trophy_index = 0;
trophy_steps = 0;
new_record_sound = -1;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");
rain_sound = audio_play_sound(snd_ryu_rain, 0, true, 0.5 * global.settings.music_volume / 100);

ryu_pose = -1;
ryu_pose_sprite = -1;
ryu_pose_frame = 0;
ryu_pose_ticks = 0;
ryu_pose_return_to_idle = false;
ryu_pose_facing = -1;
sprite_index = -1;
image_speed = 0;

ryu_start_dialogue = function(_text) {
    dialogue_lines = string_split(_text, "\n");
    dialogue_steps = 0;
    dialogue_letters = 0;
    dialogue_length = string_length(_text);
    audio_play_sound(snd_ryu_dialogue_open, 1, false);
};

ryu_update_view = function(_player) {
    var _page_left = clamp(floor(_player.x / 640) * 640, 0, 1280);
    if (view_page_left != _page_left) {
        view_page_left = _page_left;
        view_center_x = _page_left + 320;
        view_center_y = 240;
    }

    var _target_width = 640;
    var _target_x = _page_left + 320;
    var _target_y = 240;
    if (prehistorik_pickup_slot >= 0) {
        _target_width -= min(prehistorik_pickup_age, 200) * 2;
        _target_x = _player.x;
        _target_y = _player.y;
    } else if (dance_active) {
        // The viewport follows the hidden player, while Player 2 dances independently.
        _target_width = 180;
        _target_x = 1600;
        _target_y = 380;
    }
    view_width = lerp(view_width, _target_width, 0.2);
    view_center_x = lerp(view_center_x, _target_x, 0.2);
    view_center_y = lerp(view_center_y, _target_y, 0.2);

    var _width = round(view_width / 4) * 4;
    var _height = _width * 3 / 4;
    var _shake_x = 0;
    var _shake_y = 0;
    if (shake_strength > 0 && _target_width == 640) {
        _shake_x = irandom_range(-shake_strength, shake_strength - 1);
        _shake_y = irandom_range(-shake_strength, shake_strength - 1);
    }
    var _camera = view_camera[0];
    camera_set_view_size(_camera, _width, _height);
    camera_set_view_pos(_camera, round(view_center_x - _width / 2) + _shake_x,
        round(view_center_y - _height / 2) + _shake_y);
};

ryu_set_pose = function(_animation, _facing = -1, _restart = false) {
    var _left = _facing < 0;
    var _sprite = spr_ryu_idle;
    switch (_animation) {
        case 0: _sprite = _left ? spr_ryu_idle_left : spr_ryu_idle; break;
        case 7: _sprite = _left ? spr_ryu_jump_left : spr_ryu_jump; break;
        case 12: _sprite = _left ? spr_ryu_anim_12_left : spr_ryu_anim_12; break;
        case 13: _sprite = _left ? spr_ryu_anim_13_left : spr_ryu_anim_13; break;
        case 14: _sprite = spr_ryu_anim_14; break;
        case 15: _sprite = spr_ryu_anim_15; break;
        case 16: _sprite = spr_ryu_anim_16; break;
        case 17: _sprite = spr_ryu_anim_17; break;
        case 18: _sprite = spr_ryu_anim_18; break;
        case 19: _sprite = spr_ryu_anim_19; break;
        case 20: _sprite = spr_ryu_anim_20; break;
        case 21: _sprite = spr_ryu_anim_21; break;
    }

    if (_animation != ryu_pose || _restart) {
        ryu_pose_frame = 0;
        ryu_pose_ticks = 0;
    }
    ryu_pose_return_to_idle = false;
    ryu_pose = _animation;
    ryu_pose_sprite = _sprite;
    ryu_pose_facing = _facing;
    sprite_index = defeated ? -1 : _sprite;
    image_index = ryu_pose_frame;
};

take_player_shot = function(_bullet) {
    // Fusion group 732 opens the hitbox on the first Hadoken cue.
    if (fight_age < 1080 || defeated) {
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

    --hit_points;
    audio_play_sound(snd_hello_kitty_hit, 1, false);
    if (hit_flash_age < 0) {
        hit_flash_age = 0;
    }
    if (hit_points == 0) {
        defeated = true;
        ryu_set_pose(17, 1);
        image_angle = 0;
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
        audio_play_sound(snd_ryu_defeat, 1, false);

        var _seconds = attempt_steps div 50;
        var _progress = game_current_progress();
        if (_seconds < _progress.ryu_best_time) {
            _progress.ryu_best_time = _seconds;
            global.profile.dirty = true;
            new_record_sound = audio_play_sound(snd_hello_kitty_new_record, 1, false);
        }
        if (_seconds < 105 && game_trophy_unlock("RyuSpeed")) {
            array_push(trophy_titles, "Ryu Speedrun!");
        }
        if (game_trophy_unlock("Ryu")) {
            array_push(trophy_titles, "Hadoken!");
        }
        // Group 770 rewinds the defeated clock before group 693 starts the non-Ez drop.
        if (difficulty > 0 && !struct_exists(global.profile.character_unlocks, "Ryu")) {
            array_push(prehistorik_pickup_entries, {
                x: 1392, y: -9, unlock_key: "Ryu", art: 2, collected: false
            });
        }
        game_profile_save();
    }
    return true;
};

ryu_attacks_setup();
prehistorik_pickups_setup([], spr_ryu_hud_76, noone);
