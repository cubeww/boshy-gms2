if (!lethal) {
    exit;
}
var _player = instance_find(obj_player, 0);
if (_player != noone && _player.boshy_mask_meeting(id)) {
    _player.die();
}
