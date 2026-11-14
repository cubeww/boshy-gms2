if (floor_frame == floor_target) {
    exit;
}

if (++floor_frame_steps > 10) {
    floor_frame_steps -= 10;
    set_floor_frame(floor_frame + sign(floor_target - floor_frame));
}
