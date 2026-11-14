x += aimed_vx;
y += aimed_vy;
var _player = instance_find(obj_player, 0);
if (_player != noone) {
    var _px = floor(_player.x);
    var _py = floor(_player.y);
    if (aimed_active && aimed_age >= 25) {
        // G836 applies Fusion Ball speed 40, quantized to a 32-direction heading.
        var _direction = _px == floor(x) && _py == floor(y) ? 270
            : round(point_direction(floor(x), floor(y), _px, _py) / 11.25) * 11.25;
        var _vx = lengthdir_x(256, _direction);
        var _vy = lengthdir_y(256, _direction);
        aimed_vx = sign(_vx) * floor(abs(_vx) + 0.000001) * 40 / 2048;
        aimed_vy = sign(_vy) * floor(abs(_vy) + 0.000001) * 40 / 2048;
        aimed_age = 0;
    }
    if (_px >= 3867 && _px < 3911 && _py >= 377 && _py < 411) {
        aimed_active = true;
    }
    if (_px >= 4283 && _px < 4327 && _py >= 0 && _py < 42) {
        instance_destroy();
        exit;
    }
}
++aimed_age;
image_angle = (image_angle + 10) mod 360;
