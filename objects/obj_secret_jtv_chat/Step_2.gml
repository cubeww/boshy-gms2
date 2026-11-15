var _player = instance_find(obj_player, 0);
// G925 bounces off the text line's box before G926–928 scroll the messages.
if (_player != noone && !_player.dead && !_player.input_locked && _player.vsp > -2) {
    var _rows = chat.rows;
    for (var _i = 0; _i < array_length(_rows); ++_i) {
        var _row = _rows[_i];
        if (collision_rectangle(_row.x, _row.y, _row.x + _row.width - 1, _row.y + 31,
            _player, true, false) != noone) {
            _player.vsp = -5;
            _player.grounded = false;
            _player.jump_cut_enabled = false;
            break;
        }
    }
}
secret_jtv_chat_step(chat, 1, 25, 1);
