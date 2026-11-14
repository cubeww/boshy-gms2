var _player = instance_find(obj_player, 0);
if (_player == noone) {
    exit;
}
var _px = floor(_player.x);
var _py = floor(_player.y);
if (_px < 3866 || _px >= 4319 || _py < -6 || _py >= 406) {
    exit;
}
if (++shuriken_age >= 15) {
    shuriken_age = 0;
    instance_create_layer(x + irandom(399), y, "Hazards", obj_ninja_gaiden_falling_shuriken);
}
