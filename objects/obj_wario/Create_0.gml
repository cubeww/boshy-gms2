game_controller = instance_find(obj_game, 0);
stage_steps = 0;
page_left = 0;
page_top = 960;
view_width = 640;
view_center_x = 320;
view_center_y = 1200;
ice_contacts = ds_list_create();

update_view = function(_player) {
    // The backdrop uses the page origin before the collectible zoom crops the view.
    page_left = clamp(floor(_player.x / 640) * 640, 0, room_width - 640);
    page_top = clamp(floor(_player.y / 480) * 480, 0, room_height - 480);
    var _pickups = instance_find(obj_wario_pickups, 0);
    if (_pickups != noone && _pickups.prehistorik_pickup_slot >= 0) {
        view_width = lerp(view_width, 640 - min(_pickups.prehistorik_pickup_age, 200) * 2, 0.2);
        view_center_x = lerp(view_center_x, _player.x, 0.2);
        view_center_y = lerp(view_center_y, _player.y + 6, 0.2);
    } else {
        view_width = 640;
        view_center_x = page_left + 320;
        view_center_y = page_top + 240;
    }
    var _size = round(view_width / 4);
    var _width = _size * 4;
    var _height = _size * 3;
    var _camera = view_camera[0];
    camera_set_view_size(_camera, _width, _height);
    camera_set_view_pos(_camera, clamp(round(view_center_x - _width / 2), 0, room_width - _width),
        clamp(round(view_center_y - _height / 2), 0, room_height - _height));
};

game_controller.start_stage_music(snd_wario_music, true, true, 48000);
entrance_sound = play_boshy_voice(snd_tutorial_entrance, (44000 + irandom(19999) - irandom(9999)) / 48000);
var _player = instance_find(obj_player, 0);
if (_player != noone) {
    update_view(_player);
}
