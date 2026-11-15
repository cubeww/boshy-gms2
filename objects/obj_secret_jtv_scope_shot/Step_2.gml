// The authored offscreen template has no visible or colliding sprite.
if (sprite_index == -1) {
    exit;
}

var _stage = inst_secret_jtv_controller;
if (x < _stage.page_left - 80 || x > _stage.page_left + 720
    || y < _stage.page_top - 80 || y > _stage.page_top + 560) {
    instance_destroy();
    exit;
}
x = floor(travel_x);
y = floor(travel_y);
travel_x += lengthdir_x(shot_speed, image_angle);
travel_y += lengthdir_y(shot_speed, image_angle);
