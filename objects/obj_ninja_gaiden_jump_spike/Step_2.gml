// G824–835 send these spikes behind the stonework and ease to the opposite phase.
var _offset = spike_flipped ? 32 - resting_offset : resting_offset;
var _target_y = ystart + _offset;
y = floor(lerp(y, _target_y, 0.2) + clamp(_target_y, -1, 1));
