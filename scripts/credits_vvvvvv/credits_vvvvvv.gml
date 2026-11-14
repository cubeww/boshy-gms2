function credits_vvvvvv_step(_top) {
    // G935 checks the room edges and G936 checks the scrolling viewport.
    for (var _i = array_length(effects) - 1; _i >= 0; --_i) {
        var _effect = effects[_i];
        if (credits_vvvvvv_diamond_outside(_effect.x, _effect.y, _effect.angle, _top)) {
            array_delete(effects, _i, 1);
        }
    }

    // Fusion G903–905 pauses the emitter outside the expanded viewport.
    // The authored 16x16 controller's hotspot is at (0, 8).
    if (y - 8 <= _top - 300 || y + 8 >= _top + 480 + 300) {
        phase_steps = 0;
        return;
    }
    if (!instance_exists(obj_player)) {
        return;
    }

    ++phase_steps;
    if (phase_steps < 40) {
        return;
    }

    // G906–931 emit two-sided patterns relative to the original controller.
    // Each shot stores its X and Y offsets from the controller, followed by its X speed.
    static _waves = [
        [[0, -80, -3], [0, 80, -3]],
        [[0, -20, -3], [0, 20, -3]],
        [[-630, -20, 3], [-630, 20, 3]],
        [[-630, -80, 3], [-630, 80, 3]],
        [[-630, 50, 3]],
        [[0, 50, -3]],
        [[0, -32, -3], [80, 0, -3], [160, 32, -3], [240, 64, -3]],
        [[-630, 32, 3], [-710, 0, 3], [-790, -32, 3], [-870, -64, 3]],
        [[-662, 70, 3], [-646, 40, 3], [-630, -40, 3], [-614, -70, 3]],
        [[0, 70, -3], [-16, 40, -3], [-32, -40, -3], [-46, -70, -3]]
    ];
    static _cooldowns = [0, 0, 0, 0, 0, 0, -80, -80, -20, -20];
    var _pattern = irandom(array_length(_waves) - 1);
    phase_steps = _cooldowns[_pattern];

    var _shots = _waves[_pattern];
    for (var _i = 0; _i < array_length(_shots); ++_i) {
        var _shot = _shots[_i];
        var _dx = _shot[2];
        var _shot_x = x + _shot[0] + _dx;
        var _shot_y = y + _shot[1];
        // G932–933 move the new diamond before the first draw.
        if (!credits_vvvvvv_diamond_outside(_shot_x, _shot_y, 0, _top)) {
            credits_effect_spawn(spr_credits_actor_vvvvvv_diamond, _shot_x, _shot_y,
                _dx, 0, ceil((room_width + 32) / abs(_dx)), 10);
        }
    }
}

function credits_vvvvvv_diamond_outside(_x, _y, _angle, _top) {
    // Base this check on the rotated 16x16 source image extent, including transparent corners.
    var _extent = 8 * (abs(dcos(_angle)) + abs(dsin(_angle)));
    return _x + _extent <= 0 || _x - _extent >= room_width
        || _y - _extent <= _top - 64 || _y + _extent >= _top + 480 + 64;
}
