prehistorik_cave_cleanup();
prehistorik_pickups_cleanup();
audio_stop_sound(entrance_sound);
if (arrival_sound != -1) {
    audio_stop_sound(arrival_sound);
}
