if (!instance_exists(boss) || boss.victory_age >= 350) {
    instance_destroy();
    exit;
}

// Fusion's speed 100 is 12.5 room pixels per step at 50 FPS.
var _start = x;
var _bullet = id;
for (var _i = 1; _i <= 13; ++_i) {
    x = _start + min(_i, 12.5);
    var _hit = false;
    with (boss) {
        _hit = shang_tsung_victory_take_shot(_bullet);
    }
    if (_hit) {
        instance_destroy();
        exit;
    }
}
if (bbox_left >= room_width) {
    instance_destroy();
}
