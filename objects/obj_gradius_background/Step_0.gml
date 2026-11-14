// Group 898 shifts the fractional position. Groups 950–955 recycle and accelerate each star.
for (var _i = 0; _i < array_length(stars); ++_i) {
    var _star = stars[_i];
    _star.position_x -= _star.scroll_speed;
    if (_star.draw_x < -32) {
        _star.draw_y = 20 + irandom(439);
        _star.position_x = room_width + 32;
        _star.fast = false;
    }
    if (_star.scroll_speed > 25 && !_star.fast) {
        _star.scroll_speed = (300 - irandom(199)) * 0.1;
        _star.fast = true;
    }
    _star.scroll_speed += 0.1;
    _star.draw_x = floor(_star.position_x);
}
