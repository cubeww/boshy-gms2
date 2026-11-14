// G780–785 launch on contact and start sliding toward the spring's limit.
var _player = instance_find(obj_player, 0);
if (_player != noone && _player.boshy_mask_meeting(id)) {
    _player.vsp = -10;
    _player.grounded = false;
    _player.air_jump_available = false;
    spring_active = true;
    image_speed = 1;
}
if (spring_active && (travel_limit - x) * travel_step > 0) {
    x += travel_step;
}
