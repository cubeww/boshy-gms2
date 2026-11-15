function wow_login_typing() {
    var _account = instance_find(obj_wow_login_account, 0);
    return _account != noone && _account.focused;
}

function wow_login_filter(_text) {
    var _result = "";
    for (var _i = 1; _i <= string_length(_text) && string_length(_result) < 10; ++_i) {
        var _character = string_char_at(_text, _i);
        var _code = ord(_character);
        if (_code >= 32 && _code < 256 && _code != 127) {
            _result += _character;
        }
    }
    return _result;
}
