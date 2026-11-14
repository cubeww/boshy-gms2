bomberman_attacks_cleanup();
bomberman_victory_cleanup();
if (arrival_sound != -1) {
    audio_stop_sound(arrival_sound);
}
