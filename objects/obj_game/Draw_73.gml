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

if (!gameplay_room || (!show_controls && !global.settings.show_deaths && !global.settings.show_fps)) {
    exit;
}

var _camera = camera_get_active();
var _left = _camera == -1 ? 0 : camera_get_view_x(_camera);
var _top = _camera == -1 ? 0 : camera_get_view_y(_camera);
var _scale = _camera == -1 ? 1 : camera_get_view_width(_camera) / render_width;
var _right = _left + render_width;
var _deaths = global.run.deaths;
var _death_count = string(_deaths) + (_deaths == 1 ? " death" : " deaths");

if (global.settings.show_fps) {
    var _average = fps_sample_count > 0 ? round(fps_sample_total / fps_sample_count) : fps;
    draw_boshy_text("FPS - " + string(fps) + " Avg. - " + string(_average),
        _left + 384 * _scale, _top + 464 * _scale, 1, _scale);
}

if (!show_controls) {
    if (global.settings.show_deaths && room != rm_solgryn) {
        draw_boshy_text(_death_count, _left + 6 * _scale, _top + (render_height - 18) * _scale, 1, _scale);
    }
    exit;
}

draw_set_font(-1);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_set_alpha(0.76);
draw_rectangle(_left, _top, _right, _top + 42, false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
var _keys = global.settings.keys;
draw_text(_left + 10, _top + 12, game_key_name(_keys.left) + " / " + game_key_name(_keys.right)
    + " Move     " + game_key_name(_keys.jump) + " Jump     " + game_key_name(_keys.shoot) + " Shoot");
draw_text(_left + 10, _top + 30, game_key_name(_keys.restart)
    + " Restart     Esc Options     F3 Character     F4 Display     F5 Trophies");

if (global.settings.show_deaths) {
    draw_set_halign(fa_right);
    draw_text(_right - 10, _top + 12, _death_count);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
