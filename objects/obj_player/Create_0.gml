character = game_character_definition(global.profile.character_id);
if (is_undefined(character)) {
    character = boshy_character();
}
left_poses = struct_exists(character, "poses_left") ? character.poses_left : character.poses;
custom_pose_timing = struct_exists(character, "custom");
walk_sound = struct_exists(character, "walk_sound") ? character.walk_sound : noone;
walk_sound_always = struct_exists(character, "walk_sound_always") && character.walk_sound_always;
land_sound = struct_exists(character, "land_sound") ? character.land_sound : noone;
walk_instance = -1;
custom_trail_steps = 0;

stop_walk_sound = function() {
    if (walk_instance != -1) {
        audio_stop_sound(walk_instance);
        walk_instance = -1;
    }
};

update_player_shooting = function(_poses, _allow_auto_fire = true, _shoot_key = undefined) {
    if (room == rm_wow && wow_login_typing()) {
        return;
    }
    var _settings = global.settings;
    if (is_undefined(_shoot_key)) {
        _shoot_key = _settings.keys.shoot;
    }
    var _shoot = keyboard_check_pressed(_shoot_key);
    if (instance_number(obj_bullet) >= 5) {
        return;
    }
    if (_allow_auto_fire && keyboard_check(_shoot_key) && game_settings_option_value("auto_fire")) {
        shoot_hold_us += delta_time;
        if (shoot_hold_us >= 100000) {
            shoot_hold_us -= 100000;
            _shoot = true;
        }
    }
    if (!_shoot) {
        return;
    }

    var _projectile_sprite = _settings.special_shot_graphics ? character.projectile_sprite : spr_boshy_bullet;
    if (room == rm_gastly) {
        _projectile_sprite = spr_gastly_ball;
    }
    // Fusion rotates the muzzle action point with the inverted player.
    if (room != rm_missingno || !missingno_wrap_shot()) {
        instance_create_depth(x + facing * gravity_direction * character.muzzle_x,
            y + gravity_direction * character.muzzle_y, depth, obj_bullet, {
                travel_direction: facing,
                sprite_index: _projectile_sprite,
                custom_bullet: custom_character_bullet_clip(character)
            });
    }
    var _shoot_sound = _settings.special_shoot_sounds ? character.shoot_sound : snd_shoot;
    if (_shoot_sound != noone) {
        audio_play_sound(_shoot_sound, 1, false);
    }
    var _shoot_clip = _poses[PlayerPose.Shoot];
    shoot_pose_remaining = custom_pose_timing
        ? array_length(_shoot_clip.frames) * max(1, character.custom.animations[PlayerPose.Shoot].delay)
        : ceil(array_length(_shoot_clip.frames) / _shoot_clip.rate);
};

pose = PlayerPose.Idle;
pose_frame = 0;
pose_steps = 0;
chest_pose_age = -1;
shoot_pose_remaining = 0;
shoot_hold_us = 0;

hsp = 0;
vsp = 0;
facing = 1;
air_jump_available = true;
jumped_this_step = false;
jump_cut_enabled = false;
input_locked = false;
dead = false;
secret_1_1_poison_steps = 0;
gravity_direction = 1;
gravity_flip_enabled = false;
vvvvvv_trigger_list = -1;

// Opaque bounds of the original probe sprites, relative to the Player hotspot.
left_probe = { left: -8, top: -17, right: -7, bottom: -3 };
right_probe = { left: 7, top: -17, right: 8, bottom: -3 };
up_probe = { left: -6, top: -19, right: 5, bottom: -18 };
down_probe = { left: -7, top: 0, right: 6, bottom: 1 };
terrain_targets = [obj_player_backdrop, obj_solid];
// These event sheets omit the ledge lift and Down-key nudge events.
has_ledge_events = room != rm_hello_kitty && room != rm_shang_tsung
    && room != rm_desert_secret && room != rm_final_path;
switch (room) {
    case rm_green_greens:
    case rm_gastly:
    case rm_vvvvvv:
    case rm_wario:
    case rm_castlevania:
    case rm_milon:
    case rm_milon_depths:
        left_probe.top = -14;
        right_probe.top = -14;
        up_probe.top = -16;
        up_probe.bottom = -15;
        if (room != rm_gastly) {
            up_probe.left = -7;
            up_probe.right = 6;
        }
        break;
    case room1:
    case rm_tutorial:
    case rm_prehistorik:
    case rm_secret_1_1:
    case rm_secret_jtv:
    case rm_pokemon_puzzle:
    case rm_wow:
    case rm_cheetahmen:
    case rm_mega_man_world:
    case rm_kid_icarus:
    case rm_ninja_gaiden:
    case rm_desert:
    case rm_desert_secret:
    case rm_final_path:
    case rm_credits:
    case rm_prize_room:
    case rm_teleporter:
        left_probe.top = -13;
        right_probe = { left: 6, top: -13, right: 7, bottom: -2 };
        up_probe = { left: -7, top: -16, right: 6, bottom: -15 };
        break;
}

if (room == rm_wow) {
    wow_jump_speed = character.movement.jump_speed;
}

var _return_position = undefined;
if (room == rm_cheetahmen && variable_global_exists("cheetahmen_return_position")) {
    _return_position = global.cheetahmen_return_position;
    global.cheetahmen_return_position = undefined;
} else if (room == rm_castlevania && variable_global_exists("castlevania_return_position")) {
    _return_position = global.castlevania_return_position;
    global.castlevania_return_position = undefined;
} else if (room == rm_milon && variable_global_exists("milon_return_position")) {
    _return_position = global.milon_return_position;
    global.milon_return_position = undefined;
} else if (room == rm_prehistorik && variable_global_exists("prehistorik_return_position")) {
    _return_position = global.prehistorik_return_position;
    global.prehistorik_return_position = undefined;
} else if (room == rm_desert && !global.run.has_checkpoint && struct_exists(global.run, "desert_entry")) {
    _return_position = global.run.desert_entry;
}
if (!global.run.has_checkpoint && struct_exists(global.run, "teleporter_entry")
    && !is_undefined(global.run.teleporter_entry)) {
    _return_position = global.run.teleporter_entry;
}
if (!is_undefined(_return_position)) {
    x = _return_position.x;
    y = _return_position.y;
} else if (global.run.has_checkpoint) {
    x = global.run.checkpoint_x;
    y = global.run.checkpoint_y;
}
grounded = false;

if (room == rm_kid_icarus) {
    sliding_block_vertical_direction = 0;
} else if (room == rm_vvvvvv) {
    gravity_flip_latched = false;
    wrap_page_x = undefined;
    wrap_page_y = undefined;
    vvvvvv_trigger_list = ds_list_create();
    if (global.run.has_checkpoint && struct_exists(global.run, "checkpoint_gravity")) {
        gravity_direction = global.run.checkpoint_gravity;
        gravity_flip_enabled = global.run.checkpoint_gravity_flip;
        image_angle = gravity_direction < 0 ? 180 : 0;
    } else if (struct_exists(global.run, "teleporter_entry")) {
        // Fusion G735/G738 loads VVVVVV's saved gravity even when arriving by portal.
        var _progress = game_current_progress();
        gravity_direction = _progress.vvvvvv_gravity;
        gravity_flip_enabled = _progress.vvvvvv_gravity_flip;
        if (gravity_direction < 0) {
            y += 16;
            image_angle = 180;
        }
    }
}

set_gravity_direction = function(_direction, _preserve_vertical_motion = false) {
    if (_direction == gravity_direction) {
        return;
    }
    gravity_direction = _direction;
    // The inverted sprite rotates around the same hotspot after a 16-pixel shift.
    y += 16 * _direction;
    image_angle = _direction < 0 ? 180 : 0;
    if (_preserve_vertical_motion) {
        vsp = -vsp;
    }
    grounded = false;
    refresh_collision_probes();
};

visual_facing = function() {
    // Fusion rotates Boshy's image directly and reverses the costume overlay direction.
    return global.profile.character_id == CHARACTER_BOSHY ? facing : facing * gravity_direction;
};

refresh_collision_probes = function() {
    // Fusion refreshes after each X substep, before each Y substep, and once between the loops.
    probe_x = floor(x);
    probe_y = floor(y) + (gravity_direction < 0 ? 16 : 0);
};

probe_overlaps = function(_probe, _target, _x = undefined, _y = undefined) {
    if (is_undefined(_x)) {
        _x = probe_x;
        _y = probe_y;
    }
    var _left = _x + _probe.left;
    var _right = _x + _probe.right;
    var _top = _y + _probe.top;
    var _bottom = _y + _probe.bottom;

    // Test both opaque columns or rows, including the far edge of each probe.
    if (_probe.right - _probe.left == 1) {
        return collision_line(_left, _top, _left, _bottom, _target, true, true) != noone
            || collision_line(_right, _top, _right, _bottom, _target, true, true) != noone;
    }
    if (_probe.bottom - _probe.top == 1) {
        return collision_line(_left, _top, _right, _top, _target, true, true) != noone
            || collision_line(_left, _bottom, _right, _bottom, _target, true, true) != noone;
    }
    return collision_rectangle(_left, _top, _right + 1, _bottom + 1, _target, true, true) != noone;
};

down_probe_overlaps_rectangle = function(_left, _top, _right, _bottom) {
    return probe_x + down_probe.right >= _left && probe_x + down_probe.left < _right
        && probe_y + down_probe.bottom >= _top && probe_y + down_probe.top < _bottom;
};

ledge_probe_overlaps = function(_direction) {
    var _edge = probe_x + (_direction < 0 ? -7 : 6);
    return collision_point(_edge, probe_y - 1, terrain_targets, true, true) != noone
        || collision_line(_edge, probe_y, _edge - _direction, probe_y, terrain_targets, true, true) != noone;
};

side_probe_hits_unmarked_terrain = function(_side, _target) {
    // A probe can touch a marked platform and an adjacent wall in the same substep.
    // Only terrain pixels covered by the marker are passable.
    for (var _column = _side.left; _column <= _side.right; ++_column) {
        for (var _row = _side.top; _row <= _side.bottom; ++_row) {
            var _x = probe_x + _column;
            var _y = probe_y + _row;
            if (collision_point(_x, _y, _target, true, true) != noone
                && collision_point(_x, _y, obj_one_way_platform, true, true) == noone) {
                return true;
            }
        }
    }
    return false;
};

refresh_collision_probes();

boshy_mask_meeting = function(_target, _matches = undefined) {
    // The original keeps Boshy's collision silhouette under every costume.
    var _boshy = boshy_character();
    var _clip = _boshy.poses[pose];
    var _count = array_length(_clip.frames);
    var _frame = floor(pose_steps * _clip.rate);
    _frame = _clip.loop ? _frame mod _count : min(_frame, _count - 1);

    var _terrain_mask = mask_index;
    var _previous_image = image_index;
    mask_index = facing < 0 ? _boshy.sprite_left : _boshy.sprite_right;
    image_index = _clip.frames[_frame];
    var _hit = is_undefined(_matches) ? place_meeting(x, y, _target)
        : instance_place_list(x, y, _target, _matches, false) > 0;
    image_index = _previous_image;
    mask_index = _terrain_mask;
    return _hit;
};

touching_hazard = function() {
    return !global.debug_invincible && boshy_mask_meeting(obj_hazard);
};

move_player_horizontal = function(_down_held) {
    // Fusion groups 3–8 keep the loop count even when backdrop contact clears HSP.
    repeat (floor(abs(hsp))) {
        var _direction = sign(hsp);
        if (_direction != 0) {
            var _side = _direction < 0 ? left_probe : right_probe;
            var _backdrop = probe_overlaps(_side, obj_player_backdrop);
            var _solid = probe_overlaps(_side, obj_solid);
            if ((_backdrop || _solid) && probe_overlaps(_side, obj_one_way_platform)) {
                _backdrop = _backdrop && side_probe_hits_unmarked_terrain(_side, obj_player_backdrop);
                _solid = _solid && side_probe_hits_unmarked_terrain(_side, obj_solid);
            }

            if (!_backdrop && !_solid) {
                x += _direction;
            }
            if (_backdrop && !_solid) {
                hsp = 0;
            }
        }

        if (has_ledge_events && (ledge_probe_overlaps(-1) || ledge_probe_overlaps(1))) {
            --y;
        }
        refresh_collision_probes();
        if (room == rm_vvvvvv) {
            vvvvvv_wrap_horizontal();
        } else if (room == rm_desert) {
            desert_phase_move_x(id);
        }
    }

    // Groups 9 and 10 use the opposite foot probe while Down is held.
    if (has_ledge_events && _down_held) {
        if (probe_overlaps(left_probe, obj_player_backdrop) && !ledge_probe_overlaps(1)) {
            ++hsp;
        }
        if (probe_overlaps(right_probe, obj_player_backdrop) && !ledge_probe_overlaps(-1)) {
            --hsp;
        }
    }
    refresh_collision_probes();
};

move_player_vertical = function() {
    var _ground_probe = gravity_direction > 0 ? down_probe : up_probe;
    var _ceiling_probe = gravity_direction > 0 ? up_probe : down_probe;
    if (vsp != 0) {
        repeat (floor(abs(vsp)) + 1) {
            // Group 11 refreshes before groups 15, 16, and 20 on the Y loop.
            refresh_collision_probes();
            if (room == rm_secret_1_1 && secret_1_1_move_y(id)) {
                break;
            }
            if (vsp > 0) {
                if (!probe_overlaps(_ground_probe, terrain_targets)
                    || probe_overlaps(right_probe, obj_one_way_platform)
                    || probe_overlaps(left_probe, obj_one_way_platform)) {
                    y += gravity_direction;
                }
            } else if (vsp < 0) {
                if (probe_overlaps(_ceiling_probe, obj_one_way_platform) || !probe_overlaps(_ceiling_probe, terrain_targets)) {
                    y -= gravity_direction;
                } else {
                    vsp = 0;
                }
            }
            if (room == rm_cheetah_men && cheetah_men_phase_three_check_player(id)) {
                return;
            }
            if (room == rm_kid_icarus) {
                kid_icarus_collect_coins(probe_x, probe_y);
            } else if (room == rm_desert) {
                desert_phase_move_y(id);
            }
            if (vsp == 0) {
                break;
            }
            if (room == rm_vvvvvv) {
                vvvvvv_wrap_vertical();
            }
        }
    }

    // Groups 17–19 are regular events and run once after the Y loop.
    var _backdrop = probe_overlaps(_ground_probe, obj_player_backdrop);
    var _solid = probe_overlaps(_ground_probe, obj_solid);
    var _marker = probe_overlaps(_ground_probe, obj_one_way_platform);
    if (!_backdrop && !_solid) {
        vsp += character.movement.gravity;
        grounded = false;
    } else if (!_marker || (_solid && room != rm_missingno) || vsp > 0) {
        vsp = 0;
        grounded = true;
    }
};

die = function(_outside_room = false) {
    if (dead || (global.debug_invincible && !_outside_room)) {
        return false;
    }
    dead = true;
    input_locked = true;
    var _game = instance_find(obj_game, 0);
    _game.show_player_death(x, y, depth, character);
    instance_destroy();
    return true;
};

player_spawn_costume_effect();
