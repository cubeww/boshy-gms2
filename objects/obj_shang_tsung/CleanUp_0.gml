shang_tsung_victory_clean_up();

if (entrance_voice != -1) {
    audio_stop_sound(entrance_voice);
}
if (defeat_announcement != -1) {
    audio_stop_sound(defeat_announcement);
}
