actor_age = 0;
animation_frame = 0;
animation_rate = 0;
animation_loop = false;
animation_loop_start = 0;
animation_finished = false;
child_spawned = false;
actor_x = x;
actor_y = y;
image_speed = 0;
image_angle = angle;
image_xscale = facing;
shang_actor_pose(id, animation);
shang_actor_animation_step();

// Fusion initializes disappearance-only animations, then begins their one-shot playback.
if (source_handle == 14 || source_handle == 120 || source_handle == 195
    || source_handle == 321 || source_handle == 186) {
    shang_actor_animation_step();
}

if (source_handle == 193) {
    audio_play_sound(snd_shang_tsung_flying_kick, 1, false);
} else if (source_handle == 335) {
    audio_play_sound(snd_shang_tsung_toasty, 1, false);
} else if (source_handle == 336) {
    image_alpha = 1 - 40 / 128;
}
