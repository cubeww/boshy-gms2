camera_set_view_pos(view_camera[0], -1, -2);
if (struct_exists(global.run, "bomberman_arrival") && global.run.bomberman_arrival) {
    // G606 plays the reverse portal sequence once, on entry from Kid Icarus.
    global.run.bomberman_arrival = false;
    arrival_age = 0;
    arrival_sound = audio_play_sound(snd_prehistorik_descend, 1, false);
}
