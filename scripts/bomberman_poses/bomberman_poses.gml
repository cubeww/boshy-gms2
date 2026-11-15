function bomberman_pose_setup() {
    // G1210 sets the scale before the first visible frame.
    image_xscale = 2;
    image_yscale = 2;
    boss_pose = -1;
    boss_direction = 0;
    boss_last_authored_direction = -1;
    boss_pose_clock = 0;
    boss_pose_clip = undefined;
    bomberman_pose(0);
}

function bomberman_pose(_animation) {
    if (boss_pose == _animation) {
        return;
    }

    boss_pose = _animation;
    boss_pose_clock = 0;
    image_index = 0;
    bomberman_select_pose_direction();
}

function bomberman_set_direction(_direction) {
    _direction = _direction & 31;
    if (boss_direction != _direction) {
        boss_direction = _direction;
        bomberman_select_pose_direction();
    }
}

function bomberman_select_pose_direction() {
    var _directions = bomberman_pose_directions(boss_pose);
    var _clockwise = _directions[0];
    var _counterclockwise = _directions[0];
    var _clockwise_distance = 32;
    var _counterclockwise_distance = 32;
    for (var _i = 0; _i < array_length(_directions); ++_i) {
        var _clip = _directions[_i];
        var _offset = _clip.direction - boss_direction;
        if ((_offset & 31) < _counterclockwise_distance) {
            _counterclockwise = _clip;
            _counterclockwise_distance = _offset & 31;
        }
        if ((-_offset & 31) < _clockwise_distance) {
            _clockwise = _clip;
            _clockwise_distance = -_offset & 31;
        }
    }

    // Fusion keeps the previous authored direction to break equally close fallbacks.
    var _prefer_counterclockwise = boss_last_authored_direction < 0
        || ((boss_direction - boss_last_authored_direction) & 31) > 15;
    if (_counterclockwise_distance == 0) {
        boss_last_authored_direction = boss_direction;
    }
    if (_counterclockwise_distance < _clockwise_distance
        || (_counterclockwise_distance == _clockwise_distance && _prefer_counterclockwise)) {
        boss_pose_clip = _counterclockwise;
    } else {
        boss_pose_clip = _clockwise;
    }

    sprite_index = boss_pose_clip.sprite;
    image_speed = 0;
    if (image_index >= image_number) {
        image_index = 0;
    }
}

function bomberman_pose_step() {
    if (image_number <= 1) {
        return;
    }

    boss_pose_clock += boss_pose_clip.rate;
    if (boss_pose_clock > 100) {
        boss_pose_clock -= 100;
        ++image_index;
        if (image_index >= image_number) {
            image_index = boss_pose_clip.loop_frame;
        }
    }
}

function bomberman_pose_action_point() {
    return boss_pose_clip.points[floor(image_index)];
}

function bomberman_draw_pose() {
    // G1215/G1217 use Fusion's additive ink effect.
    var _flash = (hit_flash_age >= 2 && hit_flash_age < 4) || (hit_flash_age >= 6 && hit_flash_age < 8);
    if (_flash) {
        gpu_set_blendmode(bm_add);
    }
    draw_self();
    if (_flash) {
        gpu_set_blendmode(bm_normal);
    }
}

function bomberman_pose_trail_step() {
    if (visible) {
        // G1264 copies the animation and frame onto Ganon 2, at its own direction 0.
        // Its animation table has 19 entries, so the last boss pose uses its pose 18.
        var _clip = bomberman_pose_directions(min(boss_pose, 18))[0];
        instance_create_layer(x, y, "Boss Afterimages", obj_bomberman_pose_trail, {
            sprite_index: _clip.sprite,
            image_index: min(floor(image_index), array_length(_clip.points) - 1),
            image_xscale: image_xscale,
            image_yscale: image_xscale,
            image_angle: floor(dcos(game_controller.frame_elapsed_us div 3000) * 10),
            image_speed: 0,
            trail_age: 0
        });
    }

    // G1265 also advances the newly created afterimage on its first step.
    with (obj_bomberman_pose_trail) {
        image_xscale += 0.1;
        image_yscale = image_xscale;
        ++trail_age;
        image_alpha = max(0, 55 - trail_age * 5) / 255;
        if (trail_age >= 40) {
            instance_destroy();
        }
    }
}
