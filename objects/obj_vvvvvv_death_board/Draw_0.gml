// The Text Blitter extension draws its 96 × 41 pixel panel ten pixels below its origin.
var _outer = make_color_rgb(153, 150, 153);
var _glass = make_color_rgb(10, 3, 3);
draw_rectangle_color(x + 1, y + 10, x + 95, y + 42, _outer, c_white, c_white, _outer, false);
draw_rectangle_color(x + 3, y + 12, x + 92, y + 40, _glass, _glass, _glass, _glass, false);
draw_rectangle_color(x + 4, y + 43, x + 93, y + 46, c_dkgray, c_dkgray, c_black, c_black, false);
draw_rectangle_color(x + 1, y + 47, x + 95, y + 49, _outer, c_white, c_white, _outer, false);
prehistorik_death_board_draw(x + 6, y + 16);
