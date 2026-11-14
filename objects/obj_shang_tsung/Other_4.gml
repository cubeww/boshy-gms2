// Room Start applies the original crop before the first Draw event.
var _player = instance_find(obj_player, 0);
if (_player != noone) {
    camera_set_view_pos(view_camera[0], 0, (_player.y >= 480 ? 480 : 0) - 2);
}
