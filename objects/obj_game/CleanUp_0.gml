game_profile_save();

if (stage_music_instance != -1) {
    audio_stop_sound(stage_music_instance);
}
if (teleporter_arrival_sound != -1) {
    audio_stop_sound(teleporter_arrival_sound);
}
if (inbound_portal_sound != -1) {
    audio_stop_sound(inbound_portal_sound);
}

for (var _i = 0; _i < array_length(death_audio); ++_i) {
    audio_stop_sound(death_audio[_i]);
}

application_surface_draw_enable(true);
