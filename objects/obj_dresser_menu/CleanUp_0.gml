if (!is_undefined(custom_editor)) {
    custom_character_editor_close(false);
}
custom_character_unload(custom_preview_data);
if (preview_sound != -1) {
    audio_stop_sound(preview_sound);
}
