function milon_depth_guard_inside_page(_stage) {
    // Fusion's near-border condition includes the full image, even for a hidden spawner.
    var _left = x - sprite_get_xoffset(sprite_index);
    var _top = y - sprite_get_yoffset(sprite_index);
    return _left > _stage.page_left && _top > _stage.page_top
        && _left + sprite_get_width(sprite_index) < _stage.page_left + 640
        && _top + sprite_get_height(sprite_index) < _stage.page_top + 480;
}

function milon_depth_guard_backdrop(_x, _y) {
    return collision_point(_x, _y, obj_player_backdrop, true, true) != noone;
}

function milon_depth_guard_patrol() {
    // G713–721 sample the floor, walls and both ledges in event order.
    if (!milon_depth_guard_backdrop(x, y + 8)) {
        y = floor(y + guard_vertical_speed);
        guard_vertical_speed += 0.1;
    }
    if (guard_vertical_speed > 0 && milon_depth_guard_backdrop(x, y + 8)) {
        guard_vertical_speed = 0;
    }
    if (guard_facing < 0 && milon_depth_guard_backdrop(x - 8, y)) {
        guard_facing = 1;
    }
    if (guard_facing > 0 && milon_depth_guard_backdrop(x + 8, y)) {
        guard_facing = -1;
    }
    if (milon_depth_guard_backdrop(x, y + 9)) {
        if (guard_facing < 0 && !milon_depth_guard_backdrop(x - 8, y + 8)) {
            guard_facing = 1;
        }
        if (guard_facing > 0 && !milon_depth_guard_backdrop(x + 8, y + 8)) {
            guard_facing = -1;
        }
    }
    if (milon_depth_guard_backdrop(x, y + 7)) {
        --y;
    }
}

function milon_depth_guard_step(_player) {
    ++guard_alert_steps;
    ++guard_question_steps;
    milon_depth_guard_patrol();

    // G722–729 attach the previous patrol direction's detector before moving horizontally.
    var _detector = guard_detector;
    _detector.x = x;
    _detector.y = y;
    _detector.sprite_index = sprite_index == spr_milon_depth_guard_left
        ? spr_milon_depth_guard_probe_left : spr_milon_depth_guard_probe;
    var _sees_player = _player != noone && _player.boshy_mask_meeting(_detector);
    if (_sees_player && !guard_alerted) {
        guard_alerted = true;
        guard_alert_time = 60;
    } else if (!_sees_player && guard_alert_time <= 0) {
        guard_alerted = false;
        guard_announced = false;
    }
    x += guard_facing * guard_horizontal_speed;
    sprite_index = guard_facing < 0 ? spr_milon_depth_guard_left : spr_milon_depth_guard;

    with (_detector) {
        if (!place_meeting(x, y, obj_player_backdrop)) {
            image_xscale += 0.1;
        }
        if (place_meeting(x, y, obj_player_backdrop)) {
            image_xscale = max(0.1, image_xscale - 0.1);
        }
    }

    if (_player == noone) {
        guard_alerted = false;
        return;
    }
    if (guard_alerted) {
        if (!guard_announced) {
            guard_announced = true;
            guard_alert_steps = 0;
            audio_play_sound(snd_milon_depth_guard_alert, 1, false);
        }
        --guard_alert_time;
        if (_player.x != x) {
            guard_facing = sign(_player.x - x);
        }
    }
}

function milon_depth_guards_step(_player) {
    var _stage = id;
    var _shooters = [];
    var _nearby = [];
    with (obj_milon_depth_guard) {
        milon_depth_guard_step(_player);
        if (guard_alerted) {
            array_push(_shooters, id);
        }
        var _distance = _player == noone ? 100 : point_distance(x, y, _player.x, _player.y);
        // G736 detects close players even when they bypass a guard's line of sight.
        if (_distance < 50) {
            guard_alerted = true;
            guard_alert_time = 60;
        }
        if (_distance < 100) {
            array_push(_nearby, id);
        }
    }
    if (array_length(_shooters) > 0) {
        // G734 selects one alerted guard per step. The shot originates eight pixels above its hotspot.
        var _guard = _shooters[irandom(array_length(_shooters) - 1)];
        var _aim = point_direction(_guard.x, _guard.y, _player.x, _player.y);
        instance_create_depth(_guard.x, _guard.y - 8, _guard.depth - 1, obj_milon_depth_guard_projectile, {
            guard_shot_speed: 10 + irandom(4), image_angle: _aim + irandom(4) - irandom(4)
        });
    }
    if (array_length(_nearby) > 0 && --milon_guard_question_steps == 0) {
        milon_guard_question_steps = 10;
        for (var _i = 0; _i < array_length(_nearby); ++_i) {
            var _guard = _nearby[_i];
            if (!_guard.guard_alerted) {
                _guard.guard_question_steps = 0;
            }
        }
    }
    with (obj_milon_depth_guard_spawner) {
        // G741–742 spawn once while the marker is within the camera page.
        var _inside = milon_depth_guard_inside_page(_stage);
        if (_inside && !guard_spawned) {
            instance_create_depth(x, y, depth, obj_milon_depth_guard);
        }
        guard_spawned = _inside;
    }
    with (obj_milon_depth_guard) {
        if (!milon_depth_guard_inside_page(_stage)) {
            instance_destroy();
        }
    }
}

function milon_depth_guard_shot() {
    var _guard = instance_place(x, y, obj_milon_depth_guard);
    if (_guard == noone) {
        return false;
    }

    // G739–740 only a shot travelling with the guard's facing hits its back.
    var _shot_facing = reflected ? sign(dcos(reflection_angle)) : travel_direction;
    if (_shot_facing == (_guard.sprite_index == spr_milon_depth_guard_left ? -1 : 1)) {
        repeat (71) {
            instance_create_depth(_guard.x, _guard.y, _guard.depth - 1, obj_blood);
        }
        audio_play_sound(snd_mario_blood_rip, 1, false);
        instance_destroy(_guard);
    } else {
        _guard.guard_alerted = true;
        _guard.guard_alert_time = 60;
        audio_play_sound(snd_king_dedede_shoot, 1, false);
    }
    return true;
}
