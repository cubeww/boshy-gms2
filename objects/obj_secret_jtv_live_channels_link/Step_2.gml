var _player = instance_find(obj_player, 0);
// G929 enters the Live Channels menu one page above its link.
if (_player != noone && !_player.dead && !_player.input_locked && _player.boshy_mask_meeting(id)) {
    _player.y -= 480;
}
