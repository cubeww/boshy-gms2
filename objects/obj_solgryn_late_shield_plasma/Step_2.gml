var _player = instance_find(obj_player, 0);
// G802 checks the orb's previous position and only selects launched orbs.
if (launched && _player != noone && _player.boshy_mask_meeting(id) && _player.die()) {
    _player = noone;
}

++plasma_age;
image_angle = (image_angle + (plasma_age div 2)) mod 360;
image_index = (plasma_age div 2) mod image_number;
image_alpha = clamp(1 - abs(plasma_age - launch_age) / 255, 0, 1);
if (!launched && plasma_age > launch_age) {
    launched = true;
    direction = _player != noone ? point_direction(x, y, _player.x, _player.y) : 180;
    audio_play_sound(snd_solgryn_late_laser, 1, false);
}
if (!launched) {
    if (plasma_age < launch_age && image_xscale < 1) {
        image_xscale += 0.02;
        image_yscale = image_xscale;
    }
    exit;
}

// G808 keeps fractional motion separately from the integer Active position.
plasma_x += lengthdir_x(5, direction);
plasma_y += lengthdir_y(5, direction);
x = floor(plasma_x);
y = floor(plasma_y);
instance_create_layer(x, y, "Attack Effects", obj_solgryn_late_shield_plasma_trail);
if (solgryn_early_near_edge(-16)) {
    instance_destroy();
}
