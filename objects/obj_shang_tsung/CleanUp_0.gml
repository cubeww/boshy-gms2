shang_tsung_victory_clean_up();

if (intro_music != -1 && (audio_is_playing(intro_music) || audio_is_paused(intro_music))) {
    audio_stop_sound(intro_music);
}
if (entrance_voice != -1) {
    audio_stop_sound(entrance_voice);
}
if (defeat_announcement != -1) {
    audio_stop_sound(defeat_announcement);
}
