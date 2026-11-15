// G764–765 latch the spike when the player is fifty pixels away.
if (!trap_active) {
    var _player = instance_find(obj_player, 0);
    if (_player == noone || _player.x <= x - 50) {
        exit;
    }
    trap_active = true;
}

y += 20;
image_angle += 10;
image_xscale = 5;
image_yscale = 5;
