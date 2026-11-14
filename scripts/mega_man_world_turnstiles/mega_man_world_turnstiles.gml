function mega_man_world_turnstiles_step() {
    // G818–820 select sprites fully inside the camera plus a 32-pixel margin.
    var _camera = view_camera[0];
    var _left = camera_get_view_x(_camera) - 32;
    var _top = camera_get_view_y(_camera) - 32;
    var _right = _left + camera_get_view_width(_camera) + 64;
    var _bottom = _top + camera_get_view_height(_camera) + 64;

    var _hotspot_x = [0, 0, 77, 76];
    var _hotspot_y = [54, 0, 0, 54];
    with (obj_mega_man_world_turnstile) {
        // G806–817 read the angle before turning and use it for the frame and corner offset.
        var _angle = image_angle;
        turnstile_age = (turnstile_age + 1) mod 38;
        if (turnstile_age >= 20) {
            image_angle = (_angle + 5) mod 360;
        }
        var _frame = _angle div 90;
        image_index = _frame;
        var _at_corner = _angle mod 90 == 0;
        if (_at_corner && !turned_corner) {
            x -= _angle mod 180 == 0 ? 77 : 55;
        }
        turned_corner = _at_corner;

        // Each Fusion subimage is 77 x 55 with its own hotspot. The shared sprite
        // canvas is bigger, so use the source frame's rotated bounds for culling.
        var _x1 = -_hotspot_x[_frame] * image_xscale;
        var _y1 = -_hotspot_y[_frame] * image_yscale;
        var _x2 = _x1 + 77 * image_xscale;
        var _y2 = _y1 + 55 * image_yscale;
        var _cosine = dcos(image_angle);
        var _sine = dsin(image_angle);
        if (x + min(_x1 * _cosine, _x2 * _cosine) + min(_y1 * _sine, _y2 * _sine) <= _left
            || x + max(_x1 * _cosine, _x2 * _cosine) + max(_y1 * _sine, _y2 * _sine) >= _right
            || y + min(_y1 * _cosine, _y2 * _cosine) - max(_x1 * _sine, _x2 * _sine) <= _top
            || y + max(_y1 * _cosine, _y2 * _cosine) - min(_x1 * _sine, _x2 * _sine) >= _bottom) {
            instance_destroy();
        }
    }

    with (obj_mega_man_world_turnstile_trigger) {
        var _on_screen = bbox_left > _left && bbox_top > _top
            && bbox_right + 1 < _right && bbox_bottom + 1 < _bottom;
        if (_on_screen && !trigger_on_screen) {
            instance_create_layer(x, y, layer, obj_mega_man_world_turnstile);
        }
        trigger_on_screen = _on_screen;
    }
}

function mega_man_world_route_platform_step(_player) {
    with (obj_mega_man_world_route_platform) {
        if (_player != noone && _player.probe_overlaps(_player.down_probe, id)) {
            // G826 carries the rider by the previous step's displacement before advancing the route.
            route_started = true;
            _player.x += travel_x;
            _player.y += travel_y;
            _player.refresh_collision_probes();
        }

        if (route_started) {
            ++route_age;
        }

        // G830–839 use inclusive time ranges. Two segments can contribute on a boundary step.
        travel_x = 0;
        travel_y = 0;
        if (route_age >= 1 && route_age <= 50) {
            travel_x -= 1;
        }
        if (route_age >= 50 && route_age <= 100) {
            travel_y -= 1;
        }
        if (route_age >= 100 && route_age <= 180) {
            travel_x -= 2;
            travel_y -= 1;
        }
        if (route_age >= 180 && route_age <= 260) {
            travel_x -= 2;
            travel_y += 1;
        }
        if (route_age >= 260 && route_age <= 350) {
            travel_y += 1;
        }
        if (route_age >= 350 && route_age <= 475) {
            travel_x += 3;
        }
        if (route_age >= 480 && route_age <= 800) {
            travel_y -= 1;
        }
        if (route_age >= 800 && route_age <= 900) {
            travel_x -= 3;
        }
        if (route_age >= 900 && route_age <= 950) {
            travel_y += 1;
        }
        if (route_age >= 950 && route_age <= 1030) {
            travel_x -= 1;
        }
        x += travel_x;
        y += travel_y;
    }
}
