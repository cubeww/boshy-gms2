// Groups 714–715 lift both objects on probe contact or return the lift to its start.
var _player = instance_find(obj_player, 0);
var _riding = _player != noone && rider_probe_overlaps(_player.x, _player.y);
if (_riding) {
    if (y > 150) {
        y -= 2;
        _player.y -= 2;
        _player.refresh_collision_probes();
        _player.air_jump_available = true;
    }
} else if (y < ystart) {
    y += 1;
}
