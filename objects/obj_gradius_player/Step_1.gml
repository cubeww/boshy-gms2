gradius_check_hazards();
// Group 49 checks the original 30x30 player's full frame.
if (!dead && (x <= -15 || x >= room_width + 15 || y <= -5 || y >= room_height + 25)) {
    gradius_player_die(true);
}
