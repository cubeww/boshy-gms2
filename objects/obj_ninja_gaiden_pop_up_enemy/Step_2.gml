var _player = instance_find(obj_player, 0);
if (!pop_up_active && _player != noone) {
    // G809 uses the player's hotspot for both proximity checks.
    var _px = floor(_player.x);
    var _py = floor(_player.y);
    if (abs(_px - x) < 32 || (_px >= 853 && _px < 971 && _py >= 327 && _py < 466)) {
        pop_up_active = true;
        pop_up_velocity = -10;
    }
}
if (pop_up_active) {
    // G810 keeps vertical speed as a float while each assigned Y is an integer.
    y = floor(y + pop_up_velocity);
    pop_up_velocity += 0.4;
    if (y > 335 && place_meeting(x, y, obj_player_backdrop)) {
        pop_up_active = false;
    }
}
