var _boss = instance_find(obj_shang_tsung, 0);
if (_boss == noone || _boss.victory_shade_ink >= 128) {
    exit;
}

// Active 67 shades layer 2 beneath the two foreground actors.
var _previous_alpha = draw_get_alpha();
var _shade = make_color_rgb(8, 0, 0);
draw_set_alpha(1 - _boss.victory_shade_ink / 128);
draw_rectangle_color(x, y, x + 639, y + 479, _shade, _shade, _shade, _shade, false);
draw_set_alpha(_previous_alpha);
