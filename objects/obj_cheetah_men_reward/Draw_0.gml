if (pickup_age < 0) {
    if (reward_dropping && !reward_taken) {
        draw_self();
    }
    exit;
}
if (!instance_exists(pickup_player)) {
    exit;
}

// G1295 places the transforming chest three pixels above the player hotspot.
var _player = pickup_player;
if (pickup_age < 315) {
    draw_sprite(sprite_index, image_index, _player.x, _player.y - 3);
}
prehistorik_draw_chest_pose(_player);
