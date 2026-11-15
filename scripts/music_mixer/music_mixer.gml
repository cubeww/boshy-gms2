function game_mixer_normalize_offset(_offset) {
    _offset = floor(_offset);
    return _offset <= -45000 ? 0 : min(_offset, 55000);
}

function game_mixer_step(_progress) {
    if (!game_has_item("Mixer", _progress)) {
        return;
    }

    // Fusion Prehistorik G83–87 adjust the slot's frequency offset on held keys.
    var _higher = keyboard_check(vk_pageup);
    var _lower = keyboard_check(vk_pagedown);
    var _reset = keyboard_check(vk_home);
    if (!_higher && !_lower && !_reset) {
        return;
    }

    var _previous = _progress.mixer_frequency_offset;
    var _offset = is_undefined(_previous) ? 45000 : _previous;
    _offset = _reset ? 0 : game_mixer_normalize_offset(_offset + 250 * (_higher - _lower));
    if (is_undefined(_previous) || _offset != _previous) {
        _progress.mixer_frequency_offset = _offset;
        global.profile.dirty = true;
    }
}

function game_mixer_frequency(_progress, _sample_rate) {
    // G88–89 reset channel 2 at zero and use an absolute frequency otherwise.
    var _offset = _progress.mixer_frequency_offset;
    return is_undefined(_offset) || _offset == 0 ? _sample_rate : 45000 + _offset;
}
