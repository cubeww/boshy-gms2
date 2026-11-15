game_controller = instance_find(obj_game, 0);
stage_steps = 0;
entrance_sound = -1;
page_left = 0;
page_top = 0;

update_page = function(_player) {
    page_left = floor(_player.x / 640) * 640;
    page_top = floor(_player.y / 480) * 480;
};

update_view = function(_player, _pickup_age) {
    update_page(_player);
    var _camera = view_camera[0];
    camera_set_view_size(_camera, 640, 480);
    camera_set_view_pos(_camera, page_left, page_top - 2);
    chest_view_update(game_controller, _player, _pickup_age);
};
