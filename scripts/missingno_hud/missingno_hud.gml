function missingno_draw_dialogue(_text, _count) {
    var _column = 0;
    var _row = 0;
    for (var _i = 1; _i <= min(string_length(_text), _count); ++_i) {
        var _character = string_char_at(_text, _i);
        if (_character == "\n") {
            _column = 0;
            ++_row;
            continue;
        }
        var _glyph = ord(_character) - 32;
        if (_glyph >= 0 && _glyph < 224) {
            draw_sprite_part(spr_missingno_dialogue_font, 0, (_glyph mod 32) * 14, (_glyph div 32) * 18,
                14, 18, 6 + 14 * _column, 432 + 18 * _row);
        }
        ++_column;
    }
}

function missingno_draw_meter(_x, _y, _hp, _maximum) {
    var _width = floor(96 * _hp / _maximum);
    if (_width > 0) {
        var _green = make_color_rgb(28, 129, 22);
        draw_rectangle_color(_x, _y, _x + _width - 1, _y + 3, _green, _green, _green, _green, false);
    }
}

function missingno_draw_hud() {
    var _enemy_frame = enemy_level_up ? 1 : 0;
    draw_sprite(spr_missingno_player_hud, death_age > 0 ? 1 : 0, -15, 24);
    if (death_age == 0) {
        missingno_draw_meter(444, 372, 1, 1);
    }
    if (hud_opacity > 0) {
        var _alpha = hud_opacity / 128;
        draw_sprite_ext(spr_missingno_enemy_hud, _enemy_frame, 80, 64, 1, 1, 0, c_white, _alpha);
        draw_sprite_ext(spr_missingno_enemy_name, 0, 80, 48, 1, 1, 0, c_white, _alpha);
        missingno_draw_meter(122, 84, hit_points, health_meter_max);
    }
    if (show_boss_health) {
        var _health = string(hit_points) + " / " + string(health_meter_max);
        draw_boshy_text(_health, 639 - string_length(_health) * 8, 16);
    }
    if (show_boss_timer) {
        var _seconds = timer_reset_second < 0 ? scene_steps div 50 : attempt_steps div 50;
        var _time = string(_seconds) + " seconds";
        draw_boshy_text(_time, 639 - string_length(_time) * 8, show_boss_health ? 28 : 16);
    }
    missingno_draw_dialogue(read_sign, read_sign_steps div 2);
}

function missingno_draw_overlays() {
    if (attack_flash_steps > 0) {
        // G994 adds 10/128 transparency on the trigger frame and each frame after it.
        draw_sprite_ext(spr_missingno_white_overlay, 0, 0, 0, 1, 1, 0, c_white,
            (attack_flash_steps * 10 - 2) / 128);
    }
    with (obj_missingno_arena_wrap_flash) {
        if (image_alpha > 0) {
            draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_white, image_alpha);
        }
    }
}
