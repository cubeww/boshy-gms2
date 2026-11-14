// G843's 150 ms pulse alternates between eight and seven steps at 50 Hz.
dust_clock = (dust_clock + 20) mod 150;
var _player = instance_find(obj_player, 0);
if (_player != noone && !_player.dead) {
    var _contact = _player.boshy_mask_meeting(id);
    // G830 boards on new contact. Leaving a marker while still overlapping
    // the snake should let the player move away without boarding it again.
    if (!mounted && !_player.input_locked && _contact && !rider_contact) {
        mounted = true;
    }
    rider_contact = _contact;
    if (mounted && !_player.input_locked) {
        image_angle = floor(_player.hsp * 5);
        sync_rider_position(_player);
    }
    var _refill = instance_place(x, y, obj_jump_refill);
    if (_refill != noone) {
        _refill.refresh_player(_player);
    }
}

// The pickup can overlap a 32-pixel marker while easing to its anchor.
var _marker = instance_place(x, y, obj_desert_snake_dismount);
if (_marker != noone) {
    // G841 releases the rider and eases the body into the dismount marker.
    mounted = false;
    x = floor(x + (_marker.x - x) * 0.5);
}

var _spike = instance_place(x, y, obj_desert_snake_spike);
if (_spike != noone && _spike != spike_contact && _player != noone) {
    _player.die();
}
spike_contact = _spike;
