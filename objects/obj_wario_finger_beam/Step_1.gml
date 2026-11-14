if (sprite_index == -1) {
    sprite_index = spr_wario_finger_beam;
    image_index = beam_frame;
}
flight_x += motion_x;
flight_y += motion_y;
x = floor(flight_x);
y = floor(flight_y);
if (x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64) {
    instance_destroy();
}
