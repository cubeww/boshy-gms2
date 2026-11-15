function wow_mouse_room_position() {
    var _game = instance_find(obj_game, 0);
    var _pointer = _game.get_viewport_pointer();
    if (is_undefined(_pointer)) {
        return undefined;
    }
    var _camera = view_camera[0];
    var _view_width = camera_get_view_width(_camera);
    var _view_height = camera_get_view_height(_camera);
    return {
        x: floor(camera_get_view_x(_camera) + _pointer.x * _view_width),
        y: floor(camera_get_view_y(_camera) + _pointer.y * _view_height)
    };
}
