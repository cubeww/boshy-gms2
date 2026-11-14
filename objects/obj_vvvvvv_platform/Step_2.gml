// Groups 763–769 and 991–997 move first, carry the player, then reverse on contact.
y += vertical_step;
var _player = instance_find(obj_player, 0);
if (_player != noone && !_player.input_locked) {
    // Active 23 is a 16x16 rectangle with hotspot (7,13).
    var _probe_y = _player.y + (_player.gravity_direction < 0 ? 8 : 0);
    if (collision_rectangle(_player.x - 7, _probe_y - 13, _player.x + 8, _probe_y + 2, id, true, false) != noone) {
        _player.y += vertical_step;
        _player.vsp = 0;
        _player.grounded = false;
        if (keyboard_check_pressed(global.settings.keys.jump)) {
            _player.set_gravity_direction(-_player.gravity_direction);
        }
    }
}
var _contact = place_meeting(x, y, obj_player_backdrop);
if (_contact && !touching_backdrop) {
    vertical_step = -vertical_step;
}
touching_backdrop = _contact;
