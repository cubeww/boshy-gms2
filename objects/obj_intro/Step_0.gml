++elapsed_steps;
if (elapsed_steps >= 105 || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_escape)) {
    room_goto(rm_title);
    exit;
}

if (elapsed_steps == 19) {
    intro_audio = audio_play_sound(snd_intro_jae, 1, false);
}

if (elapsed_steps >= 22 && elapsed_steps <= 36) {
    var _shake_range = 36 - elapsed_steps;
    logo_offset_x = irandom(_shake_range) - irandom(_shake_range);
    logo_offset_y = irandom(_shake_range) - irandom(_shake_range);
}
