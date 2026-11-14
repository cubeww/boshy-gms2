function terrain_meeting(_x, _y) {
    if (place_meeting(_x, _y, obj_solid)) {
        return true;
    }

    // Shots and other actors check the backdrop pixels independently of their own mask type.
    var _dx = _x - x;
    var _dy = _y - y;
    return collision_rectangle(bbox_left + _dx, bbox_top + _dy, bbox_right + _dx, bbox_bottom + _dy,
        obj_player_backdrop, true, true) != noone;
}
