// G741–745 and G801–805 move the lift, carry the rider, then reverse on backdrop contact.
var _previous_top = bbox_top;
y += vertical_step;
var _player = instance_find(obj_player, 0);
if (_player != noone && !_player.jumped_this_step && _player.vsp >= 0) {
    var _feet = _player.down_probe;
    var _player_x = floor(_player.x);
    var _player_y = floor(_player.y);
    // Use the swept top surface so a rising lift can catch the feet between steps.
    if (_player_x + _feet.right >= bbox_left && _player_x + _feet.left <= bbox_right
        && _player_y + _feet.top <= _previous_top
        && _player_y + _feet.bottom >= min(_previous_top, bbox_top)) {
        _player.y = bbox_top - _feet.bottom;
        _player.vsp = 0;
        _player.grounded = true;
        _player.air_jump_available = true;
        _player.jump_cut_enabled = false;
        _player.refresh_collision_probes();
        if (!_player.input_locked && keyboard_check_pressed(global.settings.keys.jump)) {
            // The player Step may have seen an airborne player before this contact.
            launch_rider(_player);
        }
    }
}

var _contact = place_meeting(x, y, obj_player_backdrop);
if (_contact && !touching_backdrop) {
    vertical_step = -vertical_step;
}
touching_backdrop = _contact;
