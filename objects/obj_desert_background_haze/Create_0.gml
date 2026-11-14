left_limit = -1280;
right_offset = -640;
scroll_speed = -5;

advance_haze = function(_page_left) {
    // G811–813 move the haze hotspot in world X with viewport-relative wrap limits.
    var _wrap_x = _page_left + 640 + right_offset;
    if (x <= _page_left + left_limit) {
        x = _wrap_x;
    }
    x += scroll_speed;
    if (x >= _page_left) {
        x = _wrap_x;
    }
};
