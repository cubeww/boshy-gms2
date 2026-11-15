loading_progress = 0;
loading_rate = 0;
loading_clock = 0;
destination_x = 0;
destination_y = 0;
image_xscale = 0;

start_loading = function(_player, _entry_x, _entry_y, _exit_x, _exit_y) {
    _player.x = _entry_x;
    _player.y = _entry_y;
    _player.refresh_collision_probes();
    destination_x = _exit_x;
    destination_y = _exit_y;
    loading_progress = 0;
    image_xscale = 0;
};

update_loading = function(_player) {
    if (_player != noone && !_player.dead && point_in_rectangle(_player.x, _player.y, -6, 651, 638, 955)) {
        // G1052 scales before adding the current step's progress.
        image_xscale = loading_progress * 0.01;
        loading_progress += loading_rate;
        if (loading_progress >= 100) {
            _player.x = destination_x;
            _player.y = destination_y;
            _player.refresh_collision_probes();
            loading_progress = 0;
            image_xscale = 0;
        }
    }

    // G1054 rerolls the progress rate every second, including outside the loading screen.
    if (++loading_clock >= 50) {
        loading_clock = 0;
        loading_rate = (1 + irandom(29)) * 0.01;
    }
};
