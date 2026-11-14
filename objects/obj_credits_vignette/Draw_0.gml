var _top = camera_get_view_y(view_camera[0]);
if (!credits_near_view(y, _top, 400) && !array_length(effects)) {
    exit;
}

if (motion == CreditsMotion.Kracko) {
    // G891 sends the lightning sprites behind Kracko on their shared layer.
    credits_effect_draw(_top);
    draw_self();
    exit;
}

if (motion == CreditsMotion.Desert) {
    // G1088 shifts horizontal rows with the original CS_SinWave2 parameters.
    var _width = sprite_get_width(sprite_index);
    var _height = sprite_get_height(sprite_index);
    var _from = max(0, floor(_top - y));
    var _to = min(_height, ceil(_top + 480 - y));
    var _credits = instance_find(obj_credits, 0);
    var _phase = _credits != noone ? _credits.credits_age * 0.002 : 0;
    for (var _row = _from; _row < _to; ++_row) {
        var _shift = round(-sin((_row / _height + _phase) * 10) * _width * 0.008);
        draw_sprite_part(sprite_index, 0, 0, _row, _width, 1, x + _shift, y + _row);
    }
} else if (motion == CreditsMotion.MissingNoHealth) {
    draw_self();
    // Fusion's authored BossHealth counter is a full green 96x4 bar.
    missingno_draw_meter(x + missingno_meter_offset_x, y + missingno_meter_offset_y, 1, 1);
} else if (motion == CreditsMotion.Firebar) {
    if (!credits_draw_actor_panorama(17989, 300)) {
        draw_self();
    }
} else if (motion == CreditsMotion.CastleFog) {
    if (credits_draw_actor_panorama(10736, 250)) {
        var _height = sprite_get_height(sprite_index);
        var _before = max(0, 10736 - y);
        var _after = max(0, 11216 - y);
        if (_before > 0) {
            draw_sprite_part(sprite_index, 0, 0, 0, sprite_get_width(sprite_index), _before, x, y);
        }
        if (_after < _height) {
            draw_sprite_part(sprite_index, 0, 0, _after, sprite_get_width(sprite_index), _height - _after, x, y + _after);
        }
    } else {
        draw_self();
    }
} else if (motion != CreditsMotion.VvvvvvController) {
    if (additive) {
        gpu_set_blendmode(bm_add);
    }
    draw_self();
    if (additive) {
        gpu_set_blendmode(bm_normal);
    }
}
credits_effect_draw(_top);
