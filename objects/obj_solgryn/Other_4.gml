camera_set_view_pos(view_camera[0], view_left, view_top);
game_controller.show_controls = false;
game_controller.start_stage_music(snd_solgryn_music, false);
if (struct_exists(global.run, "solgryn_portal_arrival")) {
    arrival_age = 0;
    // Keep the first picture blurred even if it is drawn before the first End Step.
    var _angle = irandom(359);
    var _blur = blur_strength * 0.009;
    game_controller.directional_blur_x = dcos(_angle) * _blur;
    game_controller.directional_blur_y = dsin(_angle) * _blur;
    arrival_sound = audio_play_sound(snd_prehistorik_descend, 1, false);
    struct_remove(global.run, "solgryn_portal_arrival");
}
