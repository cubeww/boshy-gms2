for (var _i = 0; _i < array_length(teleport_sounds); ++_i) {
    var _sound = teleport_sounds[_i];
    if (_sound != -1 && audio_is_playing(_sound)) {
        audio_stop_sound(_sound);
    }
}
