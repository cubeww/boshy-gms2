if (arrival_sound != -1 && audio_is_playing(arrival_sound)) {
    audio_stop_sound(arrival_sound);
}
if (surface_exists(history_surface)) {
    surface_free(history_surface);
}
solgryn_victory_cleanup();
