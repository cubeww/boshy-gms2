var _pointer = game_controller.get_viewport_pointer();
if (is_undefined(_pointer)) {
    image_index = 0;
    exit;
}
var _camera = view_camera[0];
var _mouse_x = camera_get_view_x(_camera) + _pointer.x * camera_get_view_width(_camera);
var _mouse_y = camera_get_view_y(_camera) + _pointer.y * camera_get_view_height(_camera);
var _hover = collision_point(_mouse_x, _mouse_y, id, true, false) != noone;
image_index = _hover ? 1 : 0;

// G932 sends the player from the Live Channels search to Vaughn's stream.
if (_hover && mouse_check_button_pressed(mb_left)) {
    var _player = instance_find(obj_player, 0);
    if (_player != noone && !_player.dead && !_player.input_locked) {
        _player.x += 1280;
    }
}
