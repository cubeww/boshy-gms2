loading_x = 315;
loading_y = 850;
destination_x = 47;
destination_y = 1800;

check_rift = function(_player) {
    if (_player == noone || _player.dead || !_player.boshy_mask_meeting(id)) {
        return;
    }

    var _loading_bar = instance_find(obj_wow_login_progress, 0);
    if (_loading_bar != noone) {
        // G1061 routes the rift back through the same loading screen.
        _loading_bar.start_loading(_player, loading_x, loading_y, destination_x, destination_y);
    }
};
