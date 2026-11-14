if (!lethal) {
    exit;
}
var _player = instance_place(x, y, obj_player);
if (_player != noone) {
    _player.die();
}
