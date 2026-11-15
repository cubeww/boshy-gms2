game_controller = instance_find(obj_game, 0);
view_left = 0;
view_top = 0;
view_center_x = 0;
view_center_y = 0;
background_layer = layer_get_id("Background");
entrance_sound = -1;
portal_sound = -1;
portal_age = -1;

update_view = function(_player, _immediate = false) {
    // G1 and G855–856 center the 640x480 frame on the tracking Active.
    if (_immediate) {
        view_center_x = _player.x;
        view_center_y = _player.y;
    } else {
        view_center_x = lerp(view_center_x, _player.x, 0.1);
        view_center_y = lerp(view_center_y, _player.y, 0.1);
    }
    view_left = clamp(floor(view_center_x) - 320, 0, room_width - 640);
    view_top = clamp(floor(view_center_y) - 240, 0, room_height - 480);
    camera_set_view_pos(view_camera[0], view_left, view_top);
    layer_x(background_layer, view_left - floor(view_left * 0.5));
    layer_y(background_layer, view_top - floor(view_top * 0.1));
};

reset_hub_portal = function(_portal) {
    portal_age = -1;
    _portal.image_index = 0;
    game_controller.teleport_mosaic_columns = 0;
    game_controller.teleport_mosaic_rows = 0;
    if (portal_sound != -1) {
        audio_stop_sound(portal_sound);
        portal_sound = -1;
    }
};
