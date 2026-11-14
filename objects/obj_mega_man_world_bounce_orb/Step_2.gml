// G771–773 update the orb, accelerate it upward, and wrap it through the top of the room.
y = floor(y + vertical_speed);
if (vertical_speed > -10) {
    vertical_speed -= 0.5;
}
if (y < 0) {
    y += 470;
}

// G774/G966 test Active 8's invisible 16 x 16 mask at the player's hotspot.
var _player = instance_find(obj_player, 0);
if (_player != noone
    && collision_rectangle(_player.x - 7, _player.y - 13, _player.x + 8, _player.y + 2, id, true, false) != noone) {
    _player.vsp += vertical_speed;
    _player.grounded = false;
    _player.air_jump_available = !_player.air_jump_available;
    instance_destroy();
}
