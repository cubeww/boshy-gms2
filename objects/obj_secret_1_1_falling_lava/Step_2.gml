// G841–842 launch this tile when the player passes above its column.
var _player = instance_find(obj_player, 0);
if (!launched && _player != noone && _player.y < y && abs(_player.x - x) < 16) {
    launched = true;
    vertical_speed = -15;
}
if (launched) {
    y = floor(y + vertical_speed);
    vertical_speed += 0.5;
}
if (y > room_height + 32) {
    instance_destroy();
}
