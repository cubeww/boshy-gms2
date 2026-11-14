var _player = instance_find(obj_player, 0);
if (_player != noone && global.run.has_checkpoint && global.run.desert_snake) {
    // G852 places the snake body at the saved position before G830 takes ownership.
    x = _player.x;
    y = _player.y;
    mounted = true;
    rider_contact = true;
    sync_rider_position(_player);
}
