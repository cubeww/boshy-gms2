// The native bullet movement checks collision after each eight-pixel move.
x -= 8;
if (!place_meeting(x, y, obj_player_backdrop)) {
    x -= 2;
}
if (place_meeting(x, y, obj_player_backdrop)) {
    ninja_enemy_spawn_poof(x, y);
    instance_destroy();
} else if (bbox_right < -64) {
    instance_destroy();
}
