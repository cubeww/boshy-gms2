if (room == rm_shang_tsung) {
    with (obj_shang_tsung) {
        shang_tsung_draw_hud();
    }
} else if (room == rm_bomberman) {
    with (obj_bomberman) {
        bomberman_draw_hud();
    }
} else if (room == rm_missingno) {
    with (obj_missingno) {
        missingno_draw_hud();
        missingno_draw_overlays();
        missingno_draw_entry_grid();
    }
} else if (room == rm_solgryn) {
    var _boss = instance_find(obj_solgryn, 0);
    if (_boss != noone) {
        var _view = view_camera[0];
        var _x = camera_get_view_x(_view);
        var _y = camera_get_view_y(_view);
        var _hud_in_scene = _boss.solgryn_hud_in_scene();
        if (_hud_in_scene) {
            _boss.draw_solgryn_readouts(_x, _y, 1);
        }
        if (_boss.flash_ink < 128) {
            draw_set_alpha(1 - _boss.flash_ink / 128);
            draw_rectangle_color(_x, _y, _x + 639, _y + 479, c_white, c_white, c_white, c_white, false);
            draw_set_alpha(1);
        }
        if (_boss.arrival_age >= 0) {
            var _frame = sprite_get_number(spr_tutorial_portal_transition) - 1 - _boss.arrival_frame;
            draw_sprite(spr_tutorial_portal_transition, _frame, _x, _y);
        }
        if (_hud_in_scene) {
            _boss.draw_solgryn_health_bar(_x, _y, 1);
        }
    }
}

if (teleporter_arrival_age >= 0) {
    var _view = view_camera[0];
    var _frame = sprite_get_number(spr_tutorial_portal_transition) - 1 - floor(teleporter_arrival_age * 0.6);
    var _scale = camera_get_view_width(_view) / 640;
    draw_sprite_ext(spr_tutorial_portal_transition, _frame, camera_get_view_x(_view), camera_get_view_y(_view),
        _scale, _scale, 0, c_white, 1);
}
if (inbound_portal_age >= 0) {
    teleporter_draw_exit(inbound_portal_age);
}

if (!game_view_mirrored()) {
    var _camera = camera_get_active();
    var _left = _camera == -1 ? 0 : camera_get_view_x(_camera);
    var _top = _camera == -1 ? 0 : camera_get_view_y(_camera);
    var _scale = _camera == -1 ? 1 : camera_get_view_width(_camera) / render_width;
    draw_gameplay_readouts(_left, _top, _scale);
}
