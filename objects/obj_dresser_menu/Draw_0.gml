if (!is_undefined(custom_editor)) {
    custom_character_editor_draw();
    exit;
}

draw_sprite_part_ext(spr_options_background, 0, 144, 96, 640, 480, 0, 0, 1, 1, c_white, 94 / 255);
draw_sprite_ext(spr_dresser_spotlight, 0, 320, 214, 1, 1, 0, c_white, spotlight_alpha);

gpu_set_blendmode(bm_add);
var _fire_frames = sprite_get_number(spr_dresser_fire);
var _elapsed_ms = elapsed_steps * 1000 / game_get_speed(gamespeed_fps);
for (var _i = 0; _i < array_length(fire_positions); ++_i) {
    var _fire_x = fire_positions[_i];
    var _fire_y = round(330 + dsin(_elapsed_ms / 4 + _fire_x) * 20);
    var _frame = floor(elapsed_steps * fire_rates[_i]) mod _fire_frames;
    draw_sprite(spr_dresser_fire, _frame, _fire_x, _fire_y);
}
gpu_set_blendmode(bm_normal);

for (var _i = 0; _i < 9; ++_i) {
    draw_sprite(spr_dresser_platform_tile, 0, 250 + 16 * _i, 215);
}
draw_sprite(spr_dresser_platform_base, 0, 294, 231);

var _idle = preview_character.poses[PlayerPose.Idle];
game_character_draw(preview_character, PlayerPose.Idle, _idle.frames[floor(preview_frame)], 1, 320, 215);

draw_sprite_ext(spr_dresser_selection, 0, round(selection_x), round(selection_y), 1, 1, selection_angle, c_white, 1);
for (var _i = 0; _i < array_length(portraits); ++_i) {
    var _portrait = portraits[_i];
    var _entry = _portrait.entry;
    var _frame = _entry.icon + (floor(elapsed_steps * _entry.icon_rate / 100) mod _entry.icon_count);
    if (_portrait.status == "locked" && _entry.locked_icon >= 0) {
        _frame = _entry.locked_icon;
    }
    draw_sprite_ext(spr_dresser_portraits, _frame, _portrait.center_x, _entry.y,
        _portrait.scale, _portrait.scale, 0, c_white, 1);
}

draw_sprite(spr_dresser_custom_edit, 0, 32, 192);
draw_sprite(spr_dresser_custom_select, 0, 120, 208);
draw_sprite(spr_dresser_custom_download, 0, 77, 237);
var _heading = "Custom Characters";
for (var _i = 1; _i <= string_length(_heading); ++_i) {
    var _glyph = ord(string_char_at(_heading, _i)) - 32;
    draw_sprite_part(spr_dresser_custom_font, 0, (_glyph mod 32) * 6, (_glyph div 32) * 12, 6, 12,
        37 + (_i - 1) * 6, 179);
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_rectangle(0, 398, 640, 415, false);
draw_sprite(spr_dresser_change, 0, 250, 396);
draw_sprite(spr_dresser_title, 0, 320, 35);

if (custom_preview_name == "") {
    var _name = portraits[selected_slot].entry.name;
    var _name_x = (640 - string_length(_name) * 20) div 2;
    for (var _i = 1; _i <= string_length(_name); ++_i) {
        var _glyph = ord(string_char_at(_name, _i)) - 32;
        draw_sprite_part(spr_dresser_name_font, 0, (_glyph mod 32) * 20, (_glyph div 32) * 24, 20, 24,
            _name_x + (_i - 1) * 20, 147);
    }
} else {
    draw_set_halign(fa_center);
    draw_text(320, 147, custom_preview_name);
    draw_set_halign(fa_left);
}

if (notice_steps > 0) {
    draw_boshy_text(notice, (640 - string_length(notice) * 8) div 2, 180);
}
