if (!bridge_open) {
    exit;
}

var _player = instance_find(obj_player, 0);
var _player_alive = _player != noone && !_player.dead;

// Active 27 creates the next bridge tile five steps after it appears.
bridge_tile_delay = max(0, bridge_tile_delay - 1);
if (bridge_next_x < room_width && bridge_tile_delay == 0) {
    instance_create_layer(bridge_next_x, bridge_seed.y, "Gameplay", obj_solid, {
        sprite_index: spr_prehistorik_drop_tile
    });
    bridge_next_x += 16;
    bridge_tile_delay = 5;
}

if (_player_alive && collision_rectangle(_player.bbox_left, _player.bbox_top, _player.bbox_right,
    _player.bbox_bottom, id, true, false) != noone) {
    if (!teleporter_rush_exit()) {
        room_goto(rm_green_greens);
    }
}
