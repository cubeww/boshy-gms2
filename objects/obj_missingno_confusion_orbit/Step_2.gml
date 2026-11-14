var _player = instance_find(obj_player, 0);
if (_player == noone) {
    instance_destroy();
    exit;
}
var _angle = orbit_phase++ * 5;
x = floor(_player.x + dcos(_angle) * 32);
y = floor(_player.y - 32 - dsin(_angle) * 8);
