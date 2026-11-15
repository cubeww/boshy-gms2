function player_spawn_costume_effect(_flying = false) {
    arthur_armor_lost = false;
    switch (global.profile.character_id) {
        case 108:
            instance_create_depth(x - 16, y, depth + 1, obj_ice_climbers_follower, {
                rider: id,
                flying: _flying
            });
            break;
        case 152:
            instance_create_depth(x, y, depth - 1, obj_arthur_armor, { rider: id });
            break;
    }
}
