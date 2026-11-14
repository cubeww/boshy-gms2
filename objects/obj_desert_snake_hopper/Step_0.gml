if (++hop_clock >= hop_interval) {
    hop_clock = 0;
    hop_speed = launch_speed;
}
if (place_meeting(x, y, obj_player_backdrop)) {
    image_index = 0;
}
// G858 and its variants move while rising or clear of the backdrop.
if (hop_speed < 0 || !place_meeting(x, y, obj_player_backdrop)) {
    y = floor(y + hop_speed);
    hop_speed += gravity_step;
    image_index = 1;
}
