var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
var _boss = instance_find(obj_hello_kitty, 0);

if (combat_steps >= 0) {
    // Both halves of each copy retain the original 2048-pixel scroll height.
    var _first_y = _top + round(background_y);
    var _second_y = _top + round(background_next_y);
    draw_sprite(spr_hello_kitty_hearts_vertical_top, 0, _left, _first_y);
    draw_sprite(spr_hello_kitty_hearts_vertical_bottom, 0, _left, _first_y + 1024);
    draw_sprite(spr_hello_kitty_hearts_vertical_top, 0, _left, _second_y);
    draw_sprite(spr_hello_kitty_hearts_vertical_bottom, 0, _left, _second_y + 1024);
} else if (_boss != noone && _boss.arena_revealed) {
    draw_sprite(spr_hello_kitty_hearts_wide, 0, _left, _top);
    var _forest_alpha = 1 - (15 + (_boss.age_steps - 79) * 10) / 128;
    if (_forest_alpha > 0) {
        draw_sprite_ext(spr_hello_kitty_forest, 0, _left, _top, 1, 1, 0, c_white, _forest_alpha);
    }
} else {
    draw_sprite(spr_hello_kitty_forest, 0, _left, _top);
}

// The original animates the terrain artwork over stationary collision masks.
for (var _i = 0; _i < array_length(terrain_pieces); ++_i) {
    var _piece = terrain_pieces[_i];
    var _wave = dsin(_piece.phase * 5);
    draw_sprite_ext(_piece.sprite, 0, floor(15 + _wave * 5), _piece.y, 1, 1, _wave * _piece.tilt, c_white, 1);
}
