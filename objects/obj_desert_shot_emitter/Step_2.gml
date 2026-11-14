var _stage = instance_find(obj_desert, 0);
if (_stage == noone) {
    exit;
}
var _left = _stage.page_left;
var _top = _stage.page_top;
var _right = min(_left + 640, room_width);
var _bottom = min(_top + 480, room_height);

// G945–952 count consecutive steps with the entire emitter inside the current window.
if (x - 8 > _left && x + 8 < _right && y - 8 > _top && y + 8 < _bottom) {
    if (++onscreen_steps >= shot_interval) {
        onscreen_steps = 0;
        switch (irandom(3)) {
            case 0:
                instance_create_layer(_left + 20 + irandom(599), _top, "Hazards",
                    obj_desert_rotating_shot, { move_y: shot_speed });
                break;
            case 1:
                instance_create_layer(_left + 20 + irandom(599), _bottom, "Hazards",
                    obj_desert_rotating_shot, { move_y: -shot_speed });
                break;
            case 2:
                instance_create_layer(_left, _top + 20 + irandom(439), "Hazards",
                    obj_desert_rotating_shot, { move_x: shot_speed });
                break;
            case 3:
                instance_create_layer(_right, _top + 20 + irandom(439), "Hazards",
                    obj_desert_rotating_shot, { move_x: -shot_speed });
                break;
        }
    }
} else {
    onscreen_steps = 0;
}

with (obj_desert_rotating_shot) {
    // G953 uses the rotated image canvas before G954 moves the hazard.
    var _half_size = floor(image_index) == 0 ? 8 : 7;
    var _edge = _half_size * (abs(dcos(image_angle)) + abs(dsin(image_angle)));
    if (x - _edge <= _left - 32 || x + _edge >= _right + 32
        || y - _edge <= _top - 32 || y + _edge >= _bottom + 32) {
        instance_destroy();
        continue;
    }
    x += move_x;
    y += move_y;
    image_angle -= 2;
}
