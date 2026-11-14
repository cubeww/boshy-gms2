#macro CHARACTER_BOSHY 12

function game_character_definition(_id) {
    return _id == CHARACTER_BOSHY ? boshy_character() : stock_character(_id);
}

function game_character_status(_entry, _profile = undefined) {
    if (is_undefined(_profile)) {
        _profile = global.profile;
    }
    if (_entry.unlock_key != "" && !struct_exists(_profile.character_unlocks, _entry.unlock_key)) {
        return "locked";
    }
    return is_undefined(game_character_definition(_entry.id)) ? "unavailable" : "available";
}

function game_character_select(_entry) {
    if (game_character_status(_entry) != "available") {
        return false;
    }
    if (global.profile.character_id != _entry.id) {
        global.profile.character_id = _entry.id;
        global.profile.dirty = true;
        game_profile_save();
    }
    return true;
}

function game_character_unlock(_key) {
    if (struct_exists(global.profile.character_unlocks, _key)) {
        return false;
    }
    struct_set(global.profile.character_unlocks, _key, true);
    global.profile.dirty = true;
    game_profile_save();
    return true;
}
