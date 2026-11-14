function play_boshy_voice(_sound, _pitch = 1) {
    return audio_play_sound(_sound, 1, false, global.settings.speech_volume / 100, 0, _pitch);
}
