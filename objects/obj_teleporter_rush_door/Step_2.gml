image_index = struct_exists(game_current_progress().boss_rush_clears, rush_key) ? 1 : 0;
var _player = instance_find(obj_player, 0);
if (_player != noone && !_player.dead && !_player.input_locked && _player.boshy_mask_meeting(id)) {
    _player.input_locked = true;
    teleporter_rush_begin(rush_key, destination_room, destination_x, destination_y);
}
