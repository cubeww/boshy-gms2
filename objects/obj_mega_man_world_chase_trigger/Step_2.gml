// G786–789 count the player's hotspot inside the zone and latch the leftward chase.
if (!chase_active) {
    var _player = instance_find(obj_player, 0);
    chase_active = _player != noone && _player.x >= x && _player.x < x + zone_width
        && _player.y >= y && _player.y < y + zone_height;
}
if (chase_active) {
    with (obj_mega_man_world_chase_spike) {
        x -= 2;
    }
}
