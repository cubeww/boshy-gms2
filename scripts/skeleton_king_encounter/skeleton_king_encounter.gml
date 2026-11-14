function skeleton_king_set_view(_player) {
    if (_player == noone) {
        return;
    }

    // G832–838 retain the 640 x 480 page while the viewport samples the shake offsets.
    page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
    page_top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
    camera_set_view_pos(view_camera[0], page_left + shake_x, page_top + shake_y);
}

function skeleton_king_shot_overlaps(_shot, _target) {
    var _hit = false;
    with (_shot) {
        _hit = place_meeting(x, y, _target);
    }
    return _hit;
}

function skeleton_king_update_body_mask() {
    king_body_mask.x = king_body_x;
    king_body_mask.y = king_body_y;
    king_body_mask.sprite_index = king_body_sprite;
    king_body_mask.image_index = king_body_frame;
    king_body_mask.image_speed = 0;
    king_body_mask.image_angle = king_body_angle;
}

function skeleton_king_attach_limbs() {
    // G716 positions the arms before moving the torso to the legs.
    king_left_x = king_body_x - 48;
    king_left_y = king_body_y - 71;
    king_right_x = king_body_x + 49;
    king_right_y = king_body_y - 76;
    king_body_x = x;
    king_body_y = y + 10;
}

function skeleton_king_pose_step() {
    if (king_talk_age >= 0) {
        king_body_idle_steps = 0;
        var _frame = max(0, (++king_talk_age * 30 - 1) div 100);
        if (_frame < sprite_get_number(spr_skeleton_king_body_talk_left)) {
            king_body_sprite = spr_skeleton_king_body_talk_left;
            king_body_frame = _frame;
        } else {
            king_talk_age = -1;
        }
    }
    if (king_talk_age < 0) {
        king_body_sprite = spr_skeleton_king_body_left;
        king_body_frame = ((++king_body_idle_steps * 15 - 1) div 100) mod sprite_get_number(king_body_sprite);
    }
    king_left_frame = ((scene_steps - 1) div 10) mod sprite_get_number(spr_skeleton_king_arm_left);
}

function skeleton_king_body_step(_player) {
    if (king_age == 10) {
        attempt_steps = 0;
        game_controller.start_stage_music(snd_skeleton_king_music, false, false);
        audio_play_sound(snd_skeleton_king_lair, 1, false);
    }
    if (king_age == 10 || king_age == 35 || king_age == 70 || king_age == 120
        || king_age == 165 || king_age == 190 || king_age == 260 || king_age == 310) {
        king_talk_age = 0;
    }
    skeleton_king_pose_step();
    skeleton_king_attach_limbs();
    // G746–752 bounce the legs and then jump from the player's X before returning to the right.
    if (king_age == 1200) {
        king_velocity_y = -2;
    }
    if (king_age == 1400 && _player != noone) {
        x = _player.x;
        king_velocity_y = -40;
        shake_strength = 70;
    }
    if (king_age >= 1200 && king_age < 1280) {
        y = floor(y + king_velocity_y);
        king_velocity_y += 0.3;
    }
    if (king_age >= 1400 && king_age < 1580) {
        y = floor(y + king_velocity_y);
        king_velocity_y += 0.7;
    }
    if (king_age == 1550) {
        x = 1758;
        y = 660;
        king_velocity_y = -20;
    }
    if (king_age == 1580) {
        y = 364;
    }
    // G753 rotates the torso and legs together while the right arm follows the moving shoulder.
    if (king_age >= 1600 && king_age < 1850) {
        var _swing = dsin(scene_steps * 10) * 25;
        var _angle = _swing - frac(_swing);
        king_body_angle = _angle;
        king_legs_angle = _angle;
        king_right_x = floor(king_body_x + dcos(_angle) * 50);
        king_right_y = floor(king_body_y - 80 - dsin(_angle) * 50);
    } else if (king_age == 1850) {
        king_body_angle = 0;
        king_legs_angle = 0;
    }
    if (king_age >= 500 && king_age < 520) {
        king_left_angle += 25;
    } else if (king_age == 530) {
        king_left_angle = 0;
    }
    skeleton_king_update_body_mask();
}

function skeleton_king_stop_music() {
    if (game_controller.stage_music_instance != -1) {
        audio_stop_sound(game_controller.stage_music_instance);
        game_controller.stage_music_instance = -1;
    }
}

function skeleton_king_damage(_damage) {
    hit_points = max(0, hit_points - _damage);
    if (hit_flash_age == 0) {
        hit_flash_age = 1;
    }
    audio_play_sound(snd_mario_bump, 1, false);
    if (hit_points > 0) {
        return;
    }

    // G774–775 clear the first attack pattern and park the King for the explosion sequence.
    king_defeated = true;
    king_age = -1;
    king_body_sprite = spr_skeleton_king_body_defeat;
    king_body_frame = 0;
    king_legs_angle = 0;
    king_body_angle = 0;
    king_right_angle = 0;
    x = 1758;
    y = 354;
    skeleton_king_update_body_mask();
    skeleton_king_stop_music();
    audio_play_sound(snd_skeleton_king_burn, 1, false);
    skeleton_king_attacks_clear();
}

function skeleton_king_defeat_step() {
    ++king_defeat_steps;
    king_body_frame = min(sprite_get_number(spr_skeleton_king_body_defeat) - 1,
        (king_defeat_steps * 30 - 1) div 100);
    if (array_length(king_detached_parts) == 0) {
        skeleton_king_attach_limbs();
    }
    king_left_frame = ((scene_steps - 1) div 10) mod sprite_get_number(spr_skeleton_king_arm_left);
    // G668–669 update existing blasts before G776 creates the next one.
    for (var _i = array_length(king_explosions) - 1; _i >= 0; --_i) {
        var _explosion = king_explosions[_i];
        if (++_explosion.age >= 20) {
            array_delete(king_explosions, _i, 1);
        } else {
            _explosion.scale = 2 + (irandom(19) - irandom(19)) * 0.02;
        }
    }
    if (king_defeat_explosions < 10 && king_defeat_steps mod 15 == 0) {
        // G776 makes ten additive explosions at 300 ms intervals.
        array_push(king_explosions, {
            x: king_body_x + irandom(49) - irandom(49),
            y: king_body_y + irandom(89) - irandom(129),
            scale: 2,
            age: 0
        });
        audio_play_sound(snd_skeleton_king_rocket_explosion, 1, false);
        shake_strength = 20;
        if (++king_defeat_explosions == 10) {
            blob_age = 0;
        }
    }
    skeleton_king_update_body_mask();
}

function skeleton_king_detached_parts_step() {
    if (array_length(king_detached_parts) == 0) {
        return;
    }
    for (var _i = 0; _i < array_length(king_detached_parts); ++_i) {
        var _part = king_detached_parts[_i];
        // G783–785 choose a new impulse if a moving part's horizontal speed is zero.
        if (_i != 2 && _part.velocity_x == 0) {
            _part.velocity_y = -10 - irandom(9);
            _part.velocity_x = irandom(4) - irandom(4);
        }
        _part.x = floor(_part.x + _part.velocity_x);
        _part.y = floor(_part.y + _part.velocity_y);
        _part.velocity_y += 0.5;
        _part.angle += 5;
    }
    var _legs = king_detached_parts[0];
    var _body = king_detached_parts[1];
    var _left = king_detached_parts[2];
    var _right = king_detached_parts[3];
    x = _legs.x;
    y = _legs.y;
    king_legs_angle = _legs.angle;
    king_body_x = _body.x;
    king_body_y = _body.y;
    king_body_angle = _body.angle;
    king_left_x = _left.x;
    king_left_y = _left.y;
    king_left_angle = _left.angle;
    king_right_x = _right.x;
    king_right_y = _right.y;
    king_right_angle = _right.angle;
    skeleton_king_update_body_mask();
}

function skeleton_king_blob_set_pose(_sprite) {
    blob_pose = _sprite;
    blob_pose_steps = 0;
}

function skeleton_king_blob_cue(_age) {
    switch (_age) {
        case 50:
            blob_visible = true;
            blob_x = 1730;
            blob_y = -63;
            skeleton_king_blob_set_pose(spr_skeleton_king_blob_fall_left);
            audio_play_sound(snd_skeleton_king_hah, 1, false);
            break;
        case 160:
            blob_y = 433;
            skeleton_king_blob_set_pose(spr_skeleton_king_blob_left);
            blob_arm_active = true;
            audio_play_sound(snd_skeleton_king_hit, 1, false);
            break;
        case 180:
            // G781 creates BossChat at a fixed offset from Blob's landing position.
            blob_chat_age = 0;
            blob_chat_letters = 0;
            blob_chat_x = blob_x - 200;
            blob_chat_y = blob_y;
            audio_play_sound(snd_ryu_dialogue_open, 1, false);
            break;
        case 301:
            blob_velocity_y = -10;
            audio_play_sound(snd_skeleton_king_huh, 1, false);
            break;
        case 350:
            skeleton_king_start_blob_flyer();
            break;
        case 900:
            skeleton_king_stop_music();
            audio_play_sound(snd_skeleton_king_hah, 1, false);
            break;
        case 960:
            blob_y = 433;
            skeleton_king_blob_set_pose(spr_skeleton_king_blob_left);
            break;
        case 1000:
            blob_velocity_y = -8;
            skeleton_king_blob_set_pose(spr_skeleton_king_blob_jump_left);
            audio_play_sound(snd_skeleton_king_huh, 1, false);
            break;
        case 1200:
            var _seconds = attempt_steps div 50;
            skeleton_king_record_clear(_seconds);
            skeleton_king_unlock_trophies(_seconds);
            break;
        case 1250:
            game_controller.start_stage_music(snd_skeleton_king_win, false, false);
            break;
        case 1500:
            // G811 opens Milon's Secret Castle at (607, 1305).
            if (!teleporter_rush_exit()) {
                room_goto(rm_milon);
            }
            break;
    }
}

function skeleton_king_blob_step(_player_alive) {
    if (blob_age >= 1500) {
        return;
    }
    // G778 stops the counter at 250 or on death. The continuous events still read that age.
    ++blob_pose_steps;
    if (_player_alive && blob_age != 250) {
        skeleton_king_blob_cue(++blob_age);
    }
    if (blob_age >= 50 && blob_age < 160) {
        blob_y = floor(blob_y + blob_velocity_y);
        blob_velocity_y += 0.4;
    } else if (blob_age >= 301 && blob_age < 350) {
        blob_y = floor(blob_y + blob_velocity_y);
    } else if (blob_age > 900 && blob_age < 960) {
        blob_y = floor(blob_y + blob_velocity_y);
        blob_velocity_y += 0.6;
    } else if (blob_age > 1000 && blob_age < 1200) {
        blob_y = floor(blob_y + blob_velocity_y);
        blob_velocity_y += 0.2;
        blob_x += 4;
    }

    // The precise masks share the drawn frame and hotspot.
    if (blob_visible) {
        blob_mask.x = blob_x;
        blob_mask.y = blob_y;
        blob_mask.sprite_index = blob_pose;
        // These three Fusion clips advance by 25 and change frames after passing 100.
        var _frame = max(0, blob_pose_steps * 25 - 1) div 100;
        blob_mask.image_index = _frame mod sprite_get_number(blob_pose);
        blob_mask.image_speed = 0;
        if (array_length(king_detached_parts) == 0 && skeleton_king_blob_hits_torso()) {
            skeleton_king_detach_limbs();
        }
    }
}

function skeleton_king_blob_chat_step() {
    if (blob_chat_age < 0) {
        return;
    }
    // G904–912 add a glyph every 50 ms, then hold the full line for 32 steps.
    var _letters = min(8, (++blob_chat_age * 2) div 5);
    if (_letters > blob_chat_letters) {
        blob_chat_letters = _letters;
        audio_play_sound(snd_ryu_dialogue_tick, 1, false);
    }
    if (blob_chat_age >= 51) {
        blob_chat_age = -1;
    }
}

function skeleton_king_blob_hits_torso() {
    var _hit = false;
    var _body = king_body_mask;
    with (blob_mask) {
        _hit = place_meeting(x, y, _body);
    }
    return _hit;
}

function skeleton_king_detach_limbs() {
    // G782–789 break the King into four independently spinning parts when Blob hits the torso.
    var _parts = [
        [x, y, king_legs_angle],
        [king_body_x, king_body_y, king_body_angle],
        [king_left_x, king_left_y, king_left_angle],
        [king_right_x, king_right_y, king_right_angle]
    ];
    for (var _i = 0; _i < array_length(_parts); ++_i) {
        var _part = _parts[_i];
        array_push(king_detached_parts, {
            x: _part[0], y: _part[1], angle: _part[2],
            velocity_x: 0, velocity_y: 0
        });
    }
    blob_velocity_y = -10;
    audio_play_sound(snd_skeleton_king_burn, 1, false);
    audio_play_sound(snd_skeleton_king_boing, 1, false);
}

function skeleton_king_blob_arm_step() {
    // G790–794 swing the arm about its pivot three times, then roll it offscreen.
    if (blob_age >= 230 && blob_arm_turns < 3) {
        var _next_angle = blob_arm_angle + blob_arm_speed;
        blob_arm_angle = (_next_angle - frac(_next_angle) + 360) mod 360;
        blob_arm_speed += 0.1;
        if (blob_arm_angle >= 90) {
            blob_arm_speed *= -0.5;
            ++blob_arm_turns;
        }
    }
    if (blob_arm_turns >= 3) {
        ++blob_arm_angle;
        if (++blob_arm_exit_steps >= 40) {
            blob_arm_active = false;
            return;
        }
    }
    blob_arm_mask.sprite_index = spr_skeleton_king_blob_platform;
    blob_arm_mask.image_angle = blob_arm_angle;
    blob_arm_mask.image_xscale = 1.2;
    blob_arm_mask.image_yscale = 1.2;
}

function skeleton_king_unlock_trophies(_seconds) {
    // G570 shows the speedrun immediately. G585 waits two seconds before the clear banner.
    if (_seconds < 115 && game_trophy_unlock("SkeletonKingSpeed")) {
        skeleton_king_show_trophy(["SKELETON KING", "SPEEDRUN!"]);
    }
    if (!game_trophy_is_unlocked("SkeletonKing")) {
        // The trophy step also runs on the frame that starts this countdown.
        victory_trophy_wait = 101;
    }
}

function skeleton_king_trophy_step() {
    if (victory_trophy_age >= 0 && ++victory_trophy_age >= 226) {
        victory_trophy_age = -1;
    }
    if (victory_trophy_wait > 0 && --victory_trophy_wait == 0 && game_trophy_unlock("SkeletonKing")) {
        skeleton_king_show_trophy(["I BROUGHT LIGHT TO", "YOUR LAIR!"]);
    }
}

function skeleton_king_show_trophy(_title) {
    victory_trophy_title = _title;
    victory_trophy_age = 0;
    audio_play_sound(snd_tutorial_achievement_obtain, 1, false);
    audio_play_sound(snd_tutorial_achievement_success, 1, false);
}

function skeleton_king_record_clear(_seconds) {
    var _progress = game_current_progress();
    if (_seconds < _progress.skeleton_king_best_time) {
        _progress.skeleton_king_best_time = _seconds;
        global.profile.dirty = true;
        audio_play_sound(snd_hello_kitty_new_record, 1, false);
        game_profile_save();
    }
}

function skeleton_king_body_draw() {
    var _legs_frame = ((scene_steps * 15 - 1) div 100) mod sprite_get_number(spr_skeleton_king_legs);
    var _right_frame = ((scene_steps - 1) div 10) mod sprite_get_number(spr_skeleton_king_arm_right);
    var _invert = hit_flash_age == 2 || hit_flash_age == 3 || hit_flash_age == 6 || hit_flash_age == 7;
    _invert = _invert && shader_is_compiled(shd_boss_hit_invert);
    if (_invert) {
        shader_set(shd_boss_hit_invert);
    }
    draw_sprite_ext(king_body_sprite, king_body_frame, king_body_x, king_body_y,
        1, 1, king_body_angle, c_white, 1);
    if (_invert) {
        shader_reset();
    }
    draw_sprite_ext(spr_skeleton_king_legs, _legs_frame, x, y, 1, 1, king_legs_angle, c_white, 1);
    draw_sprite_ext(spr_skeleton_king_arm_left, king_left_frame, king_left_x, king_left_y,
        1, 1, king_left_angle, c_white, 1);
    draw_sprite_ext(spr_skeleton_king_arm_right, _right_frame, king_right_x, king_right_y,
        1, 1, king_right_angle, c_white, 1);

    if (array_length(king_explosions) > 0) {
        gpu_set_blendmode(bm_add);
        for (var _i = 0; _i < array_length(king_explosions); ++_i) {
            var _explosion = king_explosions[_i];
            var _frame = max(0, (_explosion.age * 45 - 1) div 100);
            draw_sprite_ext(spr_skeleton_king_defeat_explosion, _frame,
                _explosion.x, _explosion.y, _explosion.scale, _explosion.scale, 0, c_white, 1);
        }
        gpu_set_blendmode(bm_normal);
    }
}
