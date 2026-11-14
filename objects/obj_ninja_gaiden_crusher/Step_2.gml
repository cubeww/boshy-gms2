// G841 handles contact before G958–969 update this actor.
ninja_enemy_crusher_hit(id);
if (crusher_stopped) {
    crusher_active = false;
    y += 2;
    ninja_enemy_spawn_poof(x + irandom(31) - irandom(31), y + irandom(239) - irandom(239));
} else {
    if (!crusher_active) {
        var _player = instance_find(obj_player, 0);
        if (_player != noone && floor(_player.x) > x && floor(_player.y) < y + 240) {
            crusher_active = true;
            // G959 moves the crusher ahead of the rest of the Game layer.
            depth = -20;
        }
    }
    if (crusher_active) {
        var _command = string_char_at(crusher_path, crusher_position);
        switch (_command) {
            case "<": x -= crusher_speed; break;
            case ">": x += crusher_speed; break;
            case "v": y += crusher_speed; break;
            case "^": y -= crusher_speed; break;
            case ")": image_angle = (image_angle + crusher_turn) mod 360; break;
            case "(": image_angle = (image_angle - crusher_turn + 360) mod 360; break;
            case "$":
                crusher_speed = real(string_char_at(crusher_path, crusher_position + 1));
                crusher_position += 2;
                break;
            case "r":
                crusher_turn = real(string_char_at(crusher_path, crusher_position + 1));
                crusher_position += 2;
                break;
        }
        if (++crusher_tick >= crusher_interval) {
            ++crusher_position;
            crusher_tick = 0;
        }
    }
}
if (crusher_stopped && bbox_top >= room_height) {
    instance_destroy();
}
