for (var _index = 0; _index < array_length(quest_sounds); ++_index) {
    var _sound = quest_sounds[_index];
    if (audio_is_playing(_sound) || audio_is_paused(_sound)) {
        audio_stop_sound(_sound);
    }
}
