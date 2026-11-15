game_controller = instance_find(obj_game, 0);
var _difficulty = game_campaign_difficulty();
if (_difficulty < 0) {
    _difficulty = 1;
}
var _health_by_difficulty = [125, 230, 230, 500];
max_health = _health_by_difficulty[_difficulty];
hit_points = max_health;
easy_mode = _difficulty == 0;
show_boss_health = game_has_item("Scouter");
show_boss_timer = game_has_item("Timer");
entry_seconds = global.run.boss_entry_seconds;

scene_steps = 0;
fight_age = 0;
timer_reset_second = -1;
shield_reaction = 0;
hit_flash_age = -1;
intro_flash_steps = 0;
shake_strength = 0;
shake_x = 0;
shake_y = 0;
blur_strength = 0;
view_rotation = 0;
rotation_target = 0;
rotation_step = 0;
view_width = 640;
view_center_x = 320;
view_center_y = 240;
mouth_offsets = [[-36, -12]];
bite_active = false;
pose_speed = 0;
pose_counter = 0;
image_speed = 0;
image_xscale = 3;
image_yscale = 3;

layer_script_end("Vignette", method(id, function() {
    if (event_type == ev_draw && event_number == ev_draw_normal && intro_flash_steps > 0) {
        // Active 17 flashes above the vignette and below the foreground fog.
        var _alpha = draw_get_alpha();
        draw_set_alpha((intro_flash_steps * 10 - 2) / 128);
        draw_rectangle_color(0, 0, 640, 480, c_white, c_white, c_white, c_white, false);
        draw_set_alpha(_alpha);
    }
}));

biollante_set_pose = function(_sprite, _restart = false) {
    if (!_restart && sprite_index == _sprite) {
        return;
    }
    sprite_index = _sprite;
    image_index = 0;
    pose_counter = 0;
    pose_speed = sprite_get_speed(_sprite);
    bite_active = _sprite == spr_biollante_anim_12_left;
    // Fusion transforms the image's action point by its hotspot, scale, and angle.
    switch (_sprite) {
        case spr_biollante_idle_left:
            mouth_offsets = [[-34, -13], [-31, -14], [-37, -2]];
            break;
        case spr_biollante_anim_12_left:
            mouth_offsets = [[-44, -19], [-44, -19], [-55, 6], [-55, 6], [-55, 6], [-44, -19]];
            break;
        case spr_biollante_anim_14_left:
            mouth_offsets = [[-62, 12], [-46, -19], [-27, -38], [-6, -52], [-6, -53], [-7, -54],
                [-7, -54], [-25, -41], [-24, -41], [-24, -41], [-24, -41], [-24, -41],
                [-24, -41], [-24, -41], [-24, -41], [-24, -41], [-22, -14], [-22, -14]];
            break;
        case spr_biollante_anim_16_left:
            mouth_offsets = [[-6, -52], [-6, -53], [-7, -54], [-7, -54], [-25, -41],
                [-24, -41], [-24, -41], [-24, -41], [-24, -41], [-24, -41], [-24, -41]];
            break;
        default:
            mouth_offsets = [[-36, -12]];
    }
};

biollante_mouth = function() {
    var _offset = mouth_offsets[min(image_index, array_length(mouth_offsets) - 1)];
    var _x = _offset[0] * image_xscale;
    var _y = _offset[1] * image_yscale;
    return {x: x + _x * dcos(image_angle) + _y * dsin(image_angle),
        y: y - _x * dsin(image_angle) + _y * dcos(image_angle)};
};

biollante_advance_pose = function() {
    if (image_number <= 1) {
        return;
    }
    // TimeMovements scales the speed by elapsed time and rounds each update.
    pose_counter += floor(pose_speed * delta_time / 10000 + 0.5);
    while (pose_counter > 100) {
        pose_counter -= 100;
        if (++image_index < image_number) {
            continue;
        }
        if (sprite_index == spr_biollante_anim_16_left) {
            image_index = 4;
        } else if (sprite_index == spr_biollante_idle_left) {
            image_index = 0;
        } else {
            biollante_set_pose(spr_biollante_idle_left);
            break;
        }
    }
};

biollante_start_music = function() {
    game_controller.start_stage_music(snd_biollante_music, false, false);
};

// Return true for a consumed shot. A reflected shot retains its lifetime and owner.
take_player_shot = function(_bullet) {
    if (fight_age < 830 || victory_age >= 0 || _bullet.reflected) {
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
    if (sprite_index == spr_biollante_anim_13_left) {
        if (hit_flash_age < 0) {
            hit_flash_age = 1;
        }
        // Groups 701 and 765 select one of Fusion directions 12, 13, and 14.
        _bullet.reflected = true;
        _bullet.reflection_angle = irandom_range(12, 14) * 11.25;
        audio_play_sound(snd_green_greens_middle_reflect, 1, false);
        audio_play_sound(snd_biollante_roar, 1, false);
        biollante_set_pose(spr_biollante_anim_14_left);
        if (shield_reaction == 0) {
            shield_reaction = 1;
        }
        return false;
    }
    take_hit(sprite_index == spr_biollante_anim_14_left ? 2 : 1);
    return true;
};

take_hit = function(_damage) {
    if (hit_flash_age < 0) {
        hit_flash_age = 1;
    }
    hit_points = max(0, hit_points - _damage);
    audio_play_sound(snd_mario_bump, 1, false);
    if (hit_points == 0) {
        biollante_victory_begin(instance_find(obj_player, 0), game_controller.frame_seconds - timer_reset_second);
    }
};

biollante_draw_hud = function(_viewport) {
    var _arrival = instance_find(obj_biollante_arrival, 0);
    if (_arrival != noone && _arrival.arrival_frame < 16) {
        return;
    }
    var _scale = _viewport.width / game_controller.render_width;
    var _left = _viewport.left;
    var _top = _viewport.top;
    if (victory_age < 0) {
        var _width = floor(639 * hit_points / max_health) * _scale;
        draw_rectangle_color(_left, _top, _left + _width, _top + 9 * _scale, c_white, c_white, c_white, c_white, false);
    }

    var _status = "";
    if (show_boss_health) {
        _status = string(hit_points) + " / " + string(max_health);
    }
    if (show_boss_timer) {
        var _seconds = timer_reset_second < 0 ? entry_seconds + game_controller.frame_seconds
            : game_controller.frame_seconds - timer_reset_second;
        _status += (_status == "" ? "" : "\n") + string(_seconds) + " seconds";
    }
    if (_status != "") {
        var _lines = string_split(_status, "\n");
        for (var _i = 0; _i < array_length(_lines); ++_i) {
            var _line = _lines[_i];
            var _anchor = 638 - string_length(_line) * 8;
            draw_boshy_text(_line, _left + _anchor * _scale, _top + (14 + 12 * _i) * _scale, 1, _scale);
        }
    }
    biollante_victory_draw_hud();
};

biollante_set_pose(spr_biollante_anim_15_left, true);
biollante_attacks_create();
biollante_victory_setup();
