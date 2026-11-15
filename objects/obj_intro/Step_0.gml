skip_intro_requested = skip_intro_requested || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_escape);
if (texture_preload_pending) {
    if (texture_preload_started_us < 0) {
        texture_preload_started_us = get_timer();
        texture_prefetch("Default");
    }
    var _ready = texture_is_ready("Default");
    var _elapsed_us = get_timer() - texture_preload_started_us;
    if (_ready == 0 && _elapsed_us < 15000000) {
        exit;
    }
    texture_preload_pending = false;
    if (_ready == true) {
        show_debug_message("Startup textures ready in " + string(round(_elapsed_us / 1000)) + " ms.");
    } else {
        show_debug_message("Startup texture prefetch did not confirm readiness.");
    }
}

if (++elapsed_steps >= 105 || skip_intro_requested) {
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
