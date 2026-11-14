// Fusion's first layer has zero scroll coefficients in both axes.
var _view = view_camera[0];
draw_sprite_ext(sprite_index, image_index, x + camera_get_view_x(_view), y + camera_get_view_y(_view),
    1, 1, 0, c_white, image_alpha);
