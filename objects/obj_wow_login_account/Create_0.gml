focused = false;
typed_name = "";
nickname_age = 0;
progress_owner = game_current_progress();

loading_x = 313;
loading_y = 680;
destination_x = 47;
destination_y = 1257;

set_nickname = function(_name) {
    if (progress_owner.wow_account_name != _name) {
        progress_owner.wow_account_name = _name;
        global.profile.dirty = true;
        game_profile_save();
    }
};

update_account = function(_player) {
    // G1050 attaches the Text Blitter to the player after the first 400 ms.
    nickname_age = min(nickname_age + 1, 20);
    if (_player == noone || _player.dead) {
        focused = false;
        return;
    }

    if (point_in_rectangle(_player.x, _player.y, 2, 44, 633, 479)) {
        // G1044 forgets the previous nickname on the login page.
        set_nickname("");
    }
    if (!focused) {
        return;
    }

    // Control X reports the capital virtual-key names for letters.
    typed_name = wow_login_filter(string_upper(keyboard_string));
    keyboard_string = typed_name;
    if (!keyboard_check_pressed(vk_enter)) {
        return;
    }

    var _loading_bar = instance_find(obj_wow_login_progress, 0);
    if (_loading_bar != noone) {
        // G1049 accepts the typed name and uses Enter to start the first loading screen.
        set_nickname(typed_name);
        _loading_bar.start_loading(_player, loading_x, loading_y, destination_x, destination_y);
        audio_play_sound(snd_wow_login_enter, 1, false);
    }
    focused = false;
    typed_name = "";
    keyboard_string = "";
};
