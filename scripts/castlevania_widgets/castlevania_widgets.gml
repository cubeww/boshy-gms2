function castlevania_widget_setup() {
    widget_age = 0;
    fall_speed = 0;
    walk_speed = widget_variant == 6 ? 5 : (widget_variant == 5 ? 2 : 1);
    pose_steps = 0;
    jumping = false;
    if (widget_variant == 4) {
        sprite_index = walk_left ? spr_castlevania_ghoul_appear_left : spr_castlevania_ghoul_appear;
    } else if (widget_variant == 5) {
        sprite_index = spr_castlevania_pillar_runner;
    } else {
        sprite_index = spr_castlevania_skeleton;
    }
    image_index = 0;
    image_speed = 0;
}

function castlevania_widget_inside_view(_x, _y, _sprite, _margin = 0) {
    // Fusion checks the game page bounds. The viewport zoom changes only what is displayed.
    var _left = _x - sprite_get_xoffset(_sprite);
    var _top = _y - sprite_get_yoffset(_sprite);
    var _view_x = inst_castlevania_stage.page_left;
    var _view_y = inst_castlevania_stage.page_top;
    return _left > _view_x + _margin && _top > _view_y + _margin
        && _left + sprite_get_width(_sprite) < _view_x + 640 - _margin
        && _top + sprite_get_height(_sprite) < _view_y + 480 - _margin;
}

function castlevania_widget_terrain(_x, _y) {
    return collision_point(_x, _y, obj_player_backdrop, true, true) != noone;
}

function castlevania_widget_fall() {
    if (!castlevania_widget_terrain(x, y + 8)) {
        y = floor(y + fall_speed);
        fall_speed += 0.1;
    }
    var _landing_probe = widget_variant == 5 ? y : y + 8;
    if (fall_speed > 0 && castlevania_widget_terrain(x, _landing_probe)) {
        fall_speed = 0;
    }
}

function castlevania_widget_walk() {
    // Groups 684–694, 700–710, and their later copies sample the backdrop in order.
    castlevania_widget_fall();
    if (walk_left && castlevania_widget_terrain(x - 8, y)) {
        walk_left = false;
    }
    if (!walk_left && castlevania_widget_terrain(x + 8, y)) {
        walk_left = true;
    }

    var _turn_at_edges = widget_variant >= 4;
    if (_turn_at_edges && walk_left && !castlevania_widget_terrain(x - 8, y + 8)
        && castlevania_widget_terrain(x, y + 9)) {
        walk_left = false;
    }
    if (_turn_at_edges && !walk_left && !castlevania_widget_terrain(x + 8, y + 8)
        && castlevania_widget_terrain(x, y + 9)) {
        walk_left = true;
    }
    if (widget_variant == 3 && castlevania_widget_terrain(x, y + 9)
        && !castlevania_widget_terrain(x + (walk_left ? -8 : 8), y + 9)) {
        --y;
        fall_speed = -2.5;
    }
    if (castlevania_widget_terrain(x, y + 7)) {
        --y;
    }
    x += walk_left ? -walk_speed : walk_speed;
}

function castlevania_pillar_runner_step(_player) {
    castlevania_widget_fall();
    if (walk_left && castlevania_widget_terrain(x - 8, y)) {
        walk_left = false;
    }
    if (!walk_left && castlevania_widget_terrain(x + 8, y + 3)) {
        walk_left = true;
    }
    if (castlevania_widget_terrain(x, y + 7)) {
        --y;
    }
    x += walk_left ? -walk_speed : walk_speed;

    // Groups 776–780 animate the jump and turn toward the player.
    if (_player != noone) {
        var _distance = abs(_player.x - x);
        if (_distance < 30 && !jumping) {
            jumping = true;
            pose_steps = 0;
        }
        if (_distance < 150 && _player.y < y - 8 && castlevania_widget_terrain(x, y + 8)) {
            fall_speed = -2.5;
            --y;
        }
    }
    if (castlevania_widget_terrain(x + 9, y + 7) && !castlevania_widget_terrain(x + 9, y - 1)) {
        y -= 10;
        fall_speed = 0;
    }
    if (_player != noone && abs(_player.x - x) < 150) {
        walk_left = _player.x <= x;
    }

    // Groups 781–782 remove a struck pillar and randomly select another to cue the jump pose.
    var _pillars = [];
    with (obj_castlevania_forest_trap) {
        if (trap_kind != CastlevaniaForestTrap.Pillar) {
            continue;
        }
        if (place_meeting(x, y, other.id)) {
            instance_create_depth(x, y, depth, obj_castlevania_forest_effect, {
                forest_effect: CastlevaniaForestEffect.PillarFade
            });
            instance_destroy();
        } else {
            array_push(_pillars, id);
        }
    }
    if (array_length(_pillars) > 0 && !jumping) {
        var _selected = _pillars[irandom(array_length(_pillars) - 1)];
        if (x > _selected.x - 48) {
            jumping = true;
            pose_steps = 0;
        }
    }

    if (place_meeting(x, y, obj_castlevania_water)) {
        // Groups 783–785 scatter two pieces when the runner touches the water.
        instance_create_depth(x, y, depth, obj_castlevania_forest_effect, {
            forest_effect: CastlevaniaForestEffect.PillarDebris, horizontal_speed: 2, vertical_speed: -8
        });
        instance_create_depth(x, y, depth, obj_castlevania_forest_effect, {
            forest_effect: CastlevaniaForestEffect.PillarDebris, horizontal_speed: -2, vertical_speed: -5
        });
        audio_play_sound(snd_castlevania_enemy_die, 1, false);
        instance_destroy();
        return false;
    }
    if (x <= 2150) {
        x = 2200;
    }
    return true;
}

function castlevania_widget_pose() {
    var _sprite;
    var _rate;
    switch (widget_variant) {
        case 4:
            var _appearing = pose_steps <= 32;
            _sprite = _appearing ? (walk_left ? spr_castlevania_ghoul_appear_left : spr_castlevania_ghoul_appear)
                : (walk_left ? spr_castlevania_ghoul_left : spr_castlevania_ghoul);
            _rate = _appearing ? 25 : 15;
            if (pose_steps == 33) {
                image_index = 0;
            }
            break;
        case 5:
            if (jumping && pose_steps > 16) {
                jumping = false;
                pose_steps = 1;
            }
            _sprite = jumping ? (walk_left ? spr_castlevania_pillar_runner_jump_left : spr_castlevania_pillar_runner_jump)
                : (walk_left ? spr_castlevania_pillar_runner_left : spr_castlevania_pillar_runner);
            _rate = jumping ? 25 : 15;
            break;
        default:
            _sprite = walk_left ? spr_castlevania_skeleton_left : spr_castlevania_skeleton;
            _rate = 10;
            break;
    }
    if (sprite_index != _sprite) {
        sprite_index = _sprite;
    }
    var _age = widget_variant == 4 && pose_steps > 32 ? pose_steps - 32 : pose_steps;
    image_index = max(0, (_age * _rate - 1) div 100) mod image_number;
}

function castlevania_widget_hit(_bullet) {
    var _widget = noone;
    with (_bullet) {
        _widget = instance_place(x, y, obj_castlevania_widget);
    }
    if (_widget == noone) {
        return false;
    }
    if (_widget.widget_variant == 4) {
        // G727–728 advance the ghoul's lifetime by fifteen steps per shot.
        _widget.widget_age += 15;
        audio_play_sound(snd_mario_bump, 1, false);
        return true;
    }
    if (_bullet.object_index == obj_bullet && !_bullet.reflected) {
        _bullet.reflected = true;
        _bullet.reflection_angle = irandom_range(11, 13) * 11.25;
        audio_play_sound(snd_king_dedede_shoot, 1, false);
    }
    return false;
}
