var _stage = instance_find(obj_milon, 0);
if (sine_amplitude != 0) {
    // Groups 922–925 use opposite phases of the same room timer.
    y = floor(ystart + dsin(_stage.stage_steps * 5) * sine_amplitude);
} else {
    // Groups 895–918 ease to the opposite mark on each single or double jump.
    var _target = ystart + (_stage.depth_phase_flipped ? flipped_offset : resting_offset);
    y = floor(lerp(y, _target, 0.2) + clamp(_target, -1, 1));
}
