// Fusion's Every timer advances once per eligible frame and carries its fractional remainder.
frame_elapsed_us += delta_time;
frame_second_tick = frame_elapsed_us >= (frame_seconds + 1) * 1000000;
if (frame_second_tick) {
    ++frame_seconds;
}
