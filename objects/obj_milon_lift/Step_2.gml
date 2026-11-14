// G741–745 and G801–805 move the lift, carry the rider, then reverse on backdrop contact.
y += vertical_step;
var _player = instance_find(obj_player, 0);
// The rider probe can still overlap after launch. Carry only while the player is not jumping away.
if (_player != noone && !_player.jumped_this_step && _player.vsp >= 0
    && milon_rider_probe_overlaps(_player.x, _player.y)) {
    _player.y += vertical_step;
    _player.vsp = 0;
    _player.refresh_collision_probes();
}

var _contact = place_meeting(x, y, obj_player_backdrop);
if (_contact && !touching_backdrop) {
    vertical_step = -vertical_step;
}
touching_backdrop = _contact;
