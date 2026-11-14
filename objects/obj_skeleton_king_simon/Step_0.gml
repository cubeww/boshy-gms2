// Group 705 starts the warning once the player touches Simon.
var _player = instance_find(obj_player, 0);
if (!warned && _player != noone && _player.boshy_mask_meeting(id)) {
    warned = true;
    speech_steps = 170;
}
if (speech_steps > 0) {
    --speech_steps;
}
