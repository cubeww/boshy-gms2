audio_stop_sound(entrance_sound);
if (pipe_sound != -1 && pipe_steps < 50) {
    audio_stop_sound(pipe_sound);
}
cheetahmen_early_cleanup();
cheetahmen_late_cleanup();
prehistorik_pickups_cleanup();
