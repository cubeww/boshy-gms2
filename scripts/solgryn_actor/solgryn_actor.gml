function solgryn_actor_init() {
    image_speed = 0;
    solgryn_actor_facing = 1;
    solgryn_actor_flash_age = 0;
    solgryn_actor_set_pose(0);
}

function solgryn_actor_set_pose(_pose) {
    solgryn_actor_pose_clock = 0;
    solgryn_actor_pose_finished = false;
    solgryn_actor_current_clip = solgryn_actor_clip(_pose, solgryn_actor_facing);
    sprite_index = solgryn_actor_current_clip.sprite;
    image_index = 0;
}

function solgryn_actor_advance_pose(_age) {
    // G706–709 switch between the two authored idle clips as the box crosses the arena.
    switch (_age) {
        case 2125:
        case 2190:
            solgryn_actor_facing = -1;
            solgryn_actor_set_pose(0);
            break;
        case 2160:
        case 2230:
            solgryn_actor_facing = 1;
            solgryn_actor_set_pose(0);
            break;
        case 2680:
            solgryn_actor_set_pose(12);
            break;
        case 3300:
            solgryn_actor_set_pose(13);
            break;
        default:
            if (solgryn_actor_pose_finished) {
                solgryn_actor_set_pose(0);
            } else if (image_number > 1) {
                solgryn_actor_pose_clock += solgryn_actor_current_clip.rate;
                if (solgryn_actor_pose_clock > 100) {
                    solgryn_actor_pose_clock -= 100;
                    if (image_index + 1 < image_number) {
                        ++image_index;
                    } else if (solgryn_actor_current_clip.repeats == 0) {
                        image_index = solgryn_actor_current_clip.loop_frame;
                    } else {
                        solgryn_actor_pose_finished = true;
                    }
                }
            }
            break;
    }
}

function solgryn_actor_action_point() {
    var _point = solgryn_actor_current_clip.points[floor(image_index)];
    var _dx = _point[0] * image_xscale;
    var _dy = _point[1] * image_yscale;
    var _cos = dcos(image_angle);
    var _sin = dsin(image_angle);
    return [floor(x + _dx * _cos + _dy * _sin), floor(y + _dy * _cos - _dx * _sin)];
}

function solgryn_actor_update_orbit() {
    // G689 updates the orbit on the room clock before the boss moves.
    with (obj_solgryn_orbit) {
        // Fusion removes this active once its full sprite is beyond the frame's kill margins.
        var _extent = 16 * (abs(dcos(image_angle)) + abs(dsin(image_angle)));
        if (x + _extent < -480 || x - _extent > room_width + 480
            || y + _extent < -300 || y - _extent > room_height + 300) {
            instance_destroy();
            continue;
        }
        x = floor(other.x + dcos(orbit_steps * 2.4) * 100);
        y = floor(other.y - dsin(orbit_steps * 3) * 100);
        ++orbit_steps;
        image_angle = (image_angle + 2) mod 360;
        image_alpha = 1 - clamp(floor(dsin(50 + orbit_steps * 3) * -250), 0, 90) / 128;
    }
}

function solgryn_actor_advance_hit_flash() {
    if (solgryn_actor_flash_age > 0) {
        ++solgryn_actor_flash_age;
        if (solgryn_actor_flash_age >= 10) {
            solgryn_actor_flash_age = 0;
        }
    }
}

function solgryn_actor_hit(_shot) {
    if (!visible) {
        return false;
    }
    var _body = id;
    var _hit = false;
    with (_shot) {
        _hit = place_meeting(x, y, _body);
    }
    return _hit;
}

function solgryn_actor_hit_flash(_shot) {
    // G894 keeps counting while the hit flag remains set, including during additional hits.
    if (solgryn_actor_flash_age == 0) {
        solgryn_actor_flash_age = 1;
    }
    var _left = _shot.object_index == obj_bullet
        ? _shot.travel_direction < 0 : dcos(_shot.direction) < 0;
    instance_create_layer(_shot.x, _shot.y, "Attack Effects", obj_solgryn_hit_spark, {
        sprite_index: _left ? spr_solgryn_hit_spark_left : spr_solgryn_hit_spark_right
    });
}

function solgryn_actor_player_contact(_player) {
    // G46 uses the original Boshy silhouette against the precise qualifier-10 masks.
    return (visible && _player.boshy_mask_meeting(id))
        || _player.boshy_mask_meeting(obj_solgryn_orbit);
}

function solgryn_actor_draw() {
    var _alpha = image_alpha;
    // G895–899 alternate the native 50/128 semitransparency ink and normal copy.
    if ((solgryn_actor_flash_age >= 2 && solgryn_actor_flash_age < 4)
        || (solgryn_actor_flash_age >= 6 && solgryn_actor_flash_age < 8)) {
        _alpha *= 1 - 50 / 128;
    }
    if (!solgryn_early_teleport_draw(sprite_index, image_index, x, y, image_xscale,
        image_yscale, image_angle, image_blend, _alpha)) {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale,
            image_angle, image_blend, _alpha);
    }

    // G614 keeps the oversized bow only in Ez-mode. G900 anchors it to the current action point.
    if (difficulty == 0) {
        var _point = solgryn_actor_action_point();
        var _bow_angle = -45 * solgryn_actor_facing + dsin((scene_steps * 20) div 5) * 10;
        var _bow_scale = image_xscale * 0.4;
        draw_sprite_ext(spr_solgryn_bow, 0, _point[0] - 16 * solgryn_actor_facing,
            floor(_point[1] - 32 * image_yscale), _bow_scale, _bow_scale,
            floor(_bow_angle), c_white, image_alpha);
    }
}
