var _text = typed_name;
var _left = x;
var _top = y;
if (progress_owner.wow_account_name != "") {
    var _player = instance_find(obj_player, 0);
    if (_player == noone || _player.dead || nickname_age < 20) {
        exit;
    }
    _text = progress_owner.wow_account_name;
    // G1050 switches the 90 px field to centered alignment for the floating name.
    _left = floor(_player.x) - 44 + (90 - string_length(_text) * 8) div 2;
    _top = floor(_player.y) - 36;
}

for (var _i = 1; _i <= string_length(_text); ++_i) {
    var _glyph = ord(string_char_at(_text, _i)) - 32;
    draw_sprite_part(spr_wow_login_font, 0, (_glyph mod 32) * 8, (_glyph div 32) * 9,
        8, 9, _left + (_i - 1) * 8, _top);
}
