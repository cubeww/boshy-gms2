if (transparency < 128) {
    var _alpha = draw_get_alpha();
    draw_set_alpha(1 - transparency / 128);
    draw_rectangle_color(x, y, x + 639, y + 959, c_white, c_white, c_white, c_white, false);
    draw_set_alpha(_alpha);
}
