jumped_this_step = false;
var _previous_speed_before_input = horizontal_speed_before_input;
horizontal_speed_before_input = undefined;
if (secret_1_1_poison_steps > 0) {
    horizontal_speed_forced = false;
    stop_walk_sound();
    if (++secret_1_1_poison_steps > 50) {
        die();
    }
    exit;
}
if (room == rm_kid_icarus) {
    sliding_block_vertical_direction = 0;
}
var _keys = global.settings.keys;
var _missingno = room == rm_missingno ? instance_find(obj_missingno, 0) : noone;
var _confused = _missingno != noone && _missingno.attack_player_confused;
var _jump_key = _confused ? _keys.shoot : _keys.jump;
var _shoot_key = _confused ? _keys.jump : _keys.shoot;
var _pose_tick = custom_pose_timing ? 1 : delta_time / 20000;
if (input_locked) {
    horizontal_speed_forced = false;
    stop_walk_sound();
    if (room == rm_kid_icarus && kid_icarus_blob_player_locked()) {
        update_player_shooting(visual_facing() < 0 ? left_poses : character.poses);
        if (touching_hazard()) {
            die();
        }
    } else if (room == rm_missingno && instance_exists(obj_missingno_tri_freeze)) {
        // G24/G40 still accept a new shot during the ice lock. Auto Fire checks flag 1.
        update_player_shooting(visual_facing() < 0 ? left_poses : character.poses, false, _shoot_key);
        if (shoot_pose_remaining > 0) {
            pose = PlayerPose.Shoot;
            pose_frame = 0;
            pose_steps = 0;
            shoot_pose_remaining -= _pose_tick;
        }
        if (touching_hazard()) {
            die();
        }
    }
    exit;
}

var _snake = room == rm_desert ? desert_snake_sync_player(id) : noone;
var _settings = global.settings;
var _previous_x = x;
var _previous_y = y;
var _was_grounded = grounded;
var _movement = _snake == noone ? character.movement : desert_snake_movement();
var _jump_speed = room == rm_wow ? wow_jump_speed : _movement.jump_speed;
var _jump_pressed = keyboard_check_pressed(_jump_key);
var _depth_stage = room == rm_milon_depths ? instance_find(obj_milon, 0) : noone;
var _wall_direction = 0;
if (_depth_stage != noone) {
    if (probe_overlaps(left_probe, obj_milon_depth_wall_jump)) {
        _wall_direction = 1;
    } else if (probe_overlaps(right_probe, obj_milon_depth_wall_jump)) {
        _wall_direction = -1;
    }
}

// Fusion dispatches a new jump press before the movement loops, using the previous ground state.
if (_jump_pressed && !gravity_flip_enabled) {
    // Skeleton King group 713 gives the lift probe its own jump and sound.
    var _lift = room == rm_skeleton_king ? instance_find(obj_skeleton_king_lift, 0) : noone;
    var _lift_hop = _lift != noone && _lift.rider_probe_overlaps(x, y);
    var _milon_lift = noone;
    if (room == rm_milon) {
        // Milon groups 740 and 800 use Active 23 instead of the ground probe.
        var _player_x = x;
        var _player_y = y;
        with (obj_milon_lift) {
            if (milon_rider_probe_overlaps(_player_x, _player_y)) {
                _milon_lift = id;
                break;
            }
        }
    }
    if (_wall_direction != 0) {
        // The wall jump sets the horizontal launch away from the wall.
        force_horizontal_speed(5 * _wall_direction);
        vsp = -_movement.jump_speed;
        grounded = false;
        air_jump_available = true;
        jumped_this_step = true;
        jump_cut_enabled = true;
        var _wall_jump_sound = _settings.special_jump_sounds ? character.jump_sound : snd_jump;
        if (_wall_jump_sound != noone) {
            audio_play_sound(_wall_jump_sound, 1, false);
        }
    } else if (_milon_lift != noone) {
        _milon_lift.launch_rider(id);
    } else if (_lift_hop) {
        vsp = -_movement.jump_speed;
        grounded = false;
        jumped_this_step = true;
        audio_play_sound(snd_skeleton_king_hop, 1, false);
    } else if (grounded && _snake == noone) {
        vsp = -_jump_speed;
        grounded = false;
        jumped_this_step = true;
        jump_cut_enabled = true;
        var _jump_sound = _settings.special_jump_sounds ? character.jump_sound : snd_jump;
        if (_jump_sound != noone) {
            audio_play_sound(_jump_sound, 1, false);
        }
    } else if (air_jump_available) {
        vsp = -_jump_speed * 0.85;
        air_jump_available = false;
        jumped_this_step = true;
        jump_cut_enabled = true;
        var _air_jump_sound = _settings.special_jump_sounds ? character.air_jump_sound : snd_air_jump;
        if (_air_jump_sound != noone) {
            audio_play_sound(_air_jump_sound, 1, false);
        }
        if (_snake != noone) {
            audio_play_sound(snd_desert_snake_double_jump, 1, false);
        }
    }
}
if (_depth_stage != noone && jumped_this_step) {
    // The jump and double-jump events toggle the traps before the next movement step.
    _depth_stage.depth_phase_flipped = !_depth_stage.depth_phase_flipped;
}

var _right = keyboard_check(game_horizontal_key(_keys, true, _confused));
var _left = keyboard_check(game_horizontal_key(_keys, false, _confused));
var _low_latency = _settings.low_input_latency && _snake == noone;
// A scripted speed or wall jump owns the sweep that consumes it.
if (_low_latency && !horizontal_speed_forced) {
    // Recompute the prepared speed with the current keys from the same starting value.
    if (!is_undefined(_previous_speed_before_input)) {
        hsp = _previous_speed_before_input;
    }
    apply_horizontal_input(_movement, _right, _left);
}
horizontal_speed_forced = false;

if (_snake != noone) {
    desert_snake_move(id, _snake);
} else {
    move_player_horizontal(keyboard_check(_keys.down));
    if (room == rm_kid_icarus) {
        // The vertical loop can clear the approach speed when it reaches a sliding block.
        sliding_block_vertical_direction = sign(vsp);
    }
    move_player_vertical();
}
if (dead) {
    exit;
}
if (room == rm_solgryn && y < _previous_y && y <= 25) {
    with (obj_solgryn) {
        solgryn_late_shield_try_upper_gate(other.id, _previous_y);
    }
}
var _outside_room = bbox_top >= room_height || (gravity_direction < 0 && bbox_bottom < 0)
    || bbox_right < 0 || bbox_left >= room_width;
if (room == rm_biollante || room == rm_wario || room == rm_sanicz || room == rm_castlevania
    || room == rm_skeleton_king || room == rm_milon || room == rm_milon_depths || room == rm_mega_man
    || room == rm_mega_man_world || room == rm_shang_tsung || room == rm_kid_icarus || room == rm_bomberman
    || room == rm_ninja_gaiden || room == rm_missingno || room == rm_desert || room == rm_desert_secret
    || room == rm_final_path || room == rm_solgryn || room == rm_credits || room == rm_prize_room
    || room == rm_teleporter || room == rm_cheetah_men) {
    // Fusion's playfield boundary test uses the original 30 x 30 canvas, including transparent margins.
    var _origin_x = facing < 0 ? 14 : 15;
    _outside_room = x - _origin_x + 30 <= 0 || x - _origin_x >= room_width
        || y + 5 <= 0 || y - 25 >= room_height;
}
if (_outside_room) {
    die();
    exit;
}
if (room == rm_ninja_gaiden) {
    var _stage = instance_find(obj_ninja_gaiden, 0);
    if (_stage != noone) {
        // Projectiles cull against the new logical page before the camera draws it.
        _stage.update_page(id);
    }
} else if (room == rm_desert) {
    var _stage = instance_find(obj_desert, 0);
    if (_stage != noone) {
        _stage.update_page(id);
    }
}

if (grounded) {
    air_jump_available = true;
    if (!_was_grounded && _settings.special_jump_sounds && land_sound != noone) {
        audio_play_sound(land_sound, 1, false);
    }
}

if (_low_latency) {
    horizontal_speed_before_input = hsp;
}
// Room End Step events read the speed after the ordinary input update.
apply_horizontal_input(_movement, _right, _left);
if (_left) {
    facing = -1;
} else if (_right) {
    facing = 1;
}

if (jump_cut_enabled && vsp < 0 && !keyboard_check(_jump_key)
    && (_missingno == noone || !_missingno.attack_player_float)) {
    vsp *= 0.5;
}
if (vsp > 7) {
    vsp -= 1;
}
if (grounded) {
    jump_cut_enabled = false;
}
if (_snake != noone) {
    // Apply the stomp after shortening so the rebound gets one full movement step.
    desert_snake_stomp(id, _snake);
}
if (room == rm_vvvvvv) {
    vvvvvv_jump_step(keyboard_check(_keys.jump));
}
var _on_wall = false;
if (_depth_stage != noone || room == rm_kid_icarus) {
    var _right_wall = probe_overlaps(right_probe, obj_milon_depth_wall_jump);
    var _left_wall = probe_overlaps(left_probe, obj_milon_depth_wall_jump);
    // Fusion checks both probes in sequence before setting the facing.
    if (_right_wall && vsp > 1) {
        --vsp;
    }
    if (_left_wall && vsp > 1) {
        --vsp;
    }
    _on_wall = _right_wall || _left_wall;
    if (_on_wall) {
        facing = -1;
    }
    if (_on_wall && _jump_pressed && room == rm_kid_icarus) {
        // G898–899 launch after movement and the wall-slide checks. The left probe runs last.
        force_horizontal_speed(_left_wall ? 5 : -5);
        vsp = -_movement.jump_speed;
        grounded = false;
        air_jump_available = true;
        if (!jumped_this_step) {
            var _jump_sound = _settings.special_jump_sounds ? character.jump_sound : snd_jump;
            if (_jump_sound != noone) {
                audio_play_sound(_jump_sound, 1, false);
            }
        }
        jumped_this_step = true;
    }
} else if (room == rm_ninja_gaiden || room == rm_desert_secret) {
    // G804–808 and G903–907 use two marker families and run in source order.
    var _kinds = room == rm_ninja_gaiden ? 2 : 1;
    for (var _wall_kind = 1; _wall_kind <= _kinds; ++_wall_kind) {
        var _right_wall = ninja_gaiden_wall_contact(id, right_probe, _wall_kind);
        var _left_wall = ninja_gaiden_wall_contact(id, left_probe, _wall_kind);
        if (!_right_wall && !_left_wall) {
            continue;
        }
        if (_right_wall && vsp > 1) {
            --vsp;
        }
        if (_left_wall && vsp > 1) {
            --vsp;
        }
        _on_wall = true;
        facing = -1;
        if (_jump_pressed) {
            force_horizontal_speed(_left_wall ? 5 : -5);
            vsp = -_movement.jump_speed;
            grounded = false;
            air_jump_available = true;
            if (!jumped_this_step) {
                var _jump_sound = _settings.special_jump_sounds ? character.jump_sound : snd_jump;
                if (_jump_sound != noone) {
                    audio_play_sound(_jump_sound, 1, false);
                }
            }
            if (_wall_kind == 1) {
                audio_play_sound(snd_ninja_gaiden_wall_hit, 1, false);
            }
            jumped_this_step = true;
        }
    }
    if (jumped_this_step && room == rm_ninja_gaiden) {
        ninja_gaiden_traps_on_jump();
    }
}

var _poses = visual_facing() < 0 ? left_poses : character.poses;
if (walk_sound != noone && (_settings.character_walk_sound || walk_sound_always) && grounded && x != _previous_x) {
    if (walk_instance == -1) {
        walk_instance = audio_play_sound(walk_sound, 1, true);
    }
} else {
    stop_walk_sound();
}
var _refill = boshy_mask_contact(obj_jump_refill);
if (_refill != noone) {
    _refill.refresh_player(id);
}

update_player_shooting(_poses, true, _shoot_key);

var _next_pose = PlayerPose.Idle;
if (shoot_pose_remaining > 0) {
    _next_pose = PlayerPose.Shoot;
    shoot_pose_remaining -= _pose_tick;
} else if (_on_wall && !jumped_this_step
    && (room == rm_kid_icarus || room == rm_ninja_gaiden || room == rm_desert_secret)) {
    // G897 forces empty animation slot 15, which Fusion resolves to the idle clip.
    _next_pose = PlayerPose.Idle;
} else if (!grounded) {
    _next_pose = vsp < 0 ? PlayerPose.Rise : PlayerPose.Fall;
} else if (abs(hsp) > 1) {
    _next_pose = PlayerPose.Run;
}

if (_next_pose != pose) {
    pose = _next_pose;
    pose_frame = 0;
    pose_steps = 0;
} else {
    ++pose_steps;
    if (custom_pose_timing) {
        pose_frame = custom_character_frame_at(character.custom.animations[pose], pose_steps);
    } else {
        var _clip = _poses[pose];
        var _count = array_length(_clip.frames);
        // Fusion rounds the timed animation advance in hundredths of a frame.
        pose_frame += floor(_clip.rate * _pose_tick * 100 + 0.5) / 100;
        if (pose_frame >= _count) {
            if (_clip.loop) {
                var _loop_start = struct_exists(_clip, "loop_start") ? _clip.loop_start : 0;
                pose_frame = _loop_start + (pose_frame - _loop_start) mod (_count - _loop_start);
            } else {
                pose_frame = _count - 1;
            }
        }
    }
}

// Check hazard overlap at the final position after both movement axes.
var _hammer_hit = false;
if (room == rm_mario) {
    with (obj_mario) {
        mario_projectile_animations_step();
        _hammer_hit = mario_hammer_contact(other);
    }
}
if ((_hammer_hit || touching_hazard()) && die()) {
    exit;
}
if (room == rm_vvvvvv) {
    if (gravity_flip_enabled && vsp > 0) {
        // Group 102 fixes gravity-driven travel at 6 before the next pixel loop.
        vsp = 6;
    }
    vvvvvv_apply_triggers();
} else if (room == rm_desert) {
    desert_switch_touch(id);
}
custom_character_player_trail_step();
